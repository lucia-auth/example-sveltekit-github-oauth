<script lang="ts">
	import { enhance } from "$app/forms";

	import type { PageData } from "./$types";

	interface Props {
		data: PageData;
	}

	let { data }: Props = $props();

	const image = `https://avatars.githubusercontent.com/u/${data.user.gitHubId}`;
</script>

<h1>Hi, {data.user.username}!</h1>
<img src={image} height="100px" width="100px" alt="profile" />
<p>Email: {data.user.email}</p>
<form method="post" use:enhance>
	<button>Sign out</button>
</form>
