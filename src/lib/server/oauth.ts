import { GitHub } from "arctic";
import { GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET } from "$env/static/private";

// TODO: Update redirect URI - IMPORTANT: this overrides GitHub OAuth App settings in GitHub
export const github = new GitHub(GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, "http://localhost:5175/login/github/callback");
