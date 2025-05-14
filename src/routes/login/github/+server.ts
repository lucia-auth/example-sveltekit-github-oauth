import { dev } from "$app/environment";
import { github } from "$lib/server/oauth";
import { redirect } from "@sveltejs/kit";
import { generateState } from "arctic";

import type { RequestEvent } from "./$types";

export function GET(event: RequestEvent): Response {
	const state = generateState();
	const url = github.createAuthorizationURL(state, ["user:email"]);

	event.cookies.set("github_oauth_state", state, {
		maxAge: 60 * 10,
		secure: !dev || event.url.protocol === "https",
		path: "/"
	});

	redirect(307, url.toString());
}
