import { PrismaClient } from '@prisma/client';

import { encodeBase32, encodeHexLowerCase } from "@oslojs/encoding";
import { sha256 } from "@oslojs/crypto/sha2";

import type { RequestEvent } from "@sveltejs/kit";
import type { User } from "$lib/server/user";

const db = new PrismaClient();

export async function validateSessionToken(token: string): Promise<SessionValidationResult> {
	const sessionId = encodeHexLowerCase(sha256(new TextEncoder().encode(token)));
	
	const session = await db.session.findFirst({
		where: {
			id: sessionId
		}
	});

	let user: User | null = null;
	if (session) {
		const dbUser = await db.user.findFirst({
			where: {
				id: session.user_id
			}
		});

		user = dbUser ? {
			id: dbUser.id,
			email: dbUser.email,
			gitHubId: dbUser.github_id,
			username: dbUser.username
		} : null;

		if (Date.now() >= session.expires_at) {
			db.session.delete({
				where: {
					id: sessionId
				}
			});
			//db.execute("DELETE FROM session WHERE id = ?", [session.id]);
			//return { session: null, user: null };
		}

		if (Date.now() >= session.expires_at) {
			db.session.update({
				where: {
					id: sessionId
				},
				data: {
					expires_at: Date.now() + 1000 * 60 * 60 * 24 * 7
				}
			})
		}
	}

	const mappedSession = session ? {
		id: session.id,
		userId: session.user_id,
		expiresAt: Number(session.expires_at)
	} : null;

	return { session: mappedSession, user };
}

export async function invalidateSession(sessionId: string): Promise<void> {
	const deleteSession = await db.session.delete({
		where: {
			id: sessionId
		}
	})
	//console.log("deleteSession: ", deleteSession);
}

export async function invalidateUserSessions(userId: string): Promise<void> {
	const deleteUserSession = await db.session.deleteMany({
		where: {
			id: userId
		}
	})
}

export function setSessionTokenCookie(event: RequestEvent, token: string, expires_at: number): void {
	event.cookies.set("session", token, {
		httpOnly: true,
		path: "/",
		secure: import.meta.env.PROD,
		sameSite: "lax",
		expires: new Date(expires_at)
	});
}

export function deleteSessionTokenCookie(event: RequestEvent): void {
	event.cookies.set("session", "", {
		httpOnly: true,
		path: "/",
		secure: import.meta.env.PROD,
		sameSite: "lax",
		maxAge: 0
	});
}

export function generateSessionToken(): string {
	const tokenBytes = new Uint8Array(20);
	crypto.getRandomValues(tokenBytes);
	const token = encodeBase32(tokenBytes).toLowerCase();
	return token;
}

export async function createSession(token: string, userId: string): Promise<Session> {
	const sessionId = encodeHexLowerCase(sha256(new TextEncoder().encode(token)));
	const session: Session = {
		id: sessionId,
		userId,
		expiresAt: Date.now() + 1000 * 60 * 60 * 24 * 7
	};
	const dbSession = await db.session.create({
		data: {
			id: session.id,
			user_id: session.userId,
			expires_at: session.expiresAt
		}
	});

	return session;
}

export interface Session {
	id: string;
	expiresAt: number;
	userId: string;
}

type SessionValidationResult = { session: Session | null ; user: User | null };
