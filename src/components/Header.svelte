<script>
  import SignInAndOnButtons from './SignInAndOnButtons.svelte';
  import SignOut from './SignOut.svelte';
  import { isUserLoggedIn, accountType } from '../stores';

  let a;
  let b;

  isUserLoggedIn.subscribe(v => {
    a = v;
  });

  accountType.subscribe(v => {
    b = v;
  });
</script>

<header class="text-gray-600 body-font border-b-2 border-gray-200">
  <div
    class="container mx-auto flex flex-wrap p-5 flex-col md:flex-row items-center"
  >
    <a
      href="./#/"
      class="flex title-font font-medium items-center mb-4 md:mb-0 cursor-pointer"
    >
      <!-- prettier-ignore -->
      <img
        src="./assets/icons/logo.png"
        alt='Wypożyczalnia aut "6.3 AMG Mordo"'
      />
      <span class="ml-3 text-xl text-gray-900"
        >Wypożyczalnia aut "6.3 AMG Mordo"</span
      >
    </a>
    <nav
      class="md:mr-auto md:ml-4 md:py-1 md:pl-4 md:border-l md:border-gray-400	flex flex-wrap items-center text-base justify-center"
    >
      <a href="./#/cars" class="mr-5 hover:text-gray-900"
        ><span class="text-gray-600">Nasze auta</span></a
      >
      {#if a}
        <a href="./#/my-reservations" class="mr-5 hover:text-gray-900"
          ><span class="text-gray-600">Moje rezerwacje</span></a
        >
      {/if}
      {#if b == 'administrator' || b == 'moderator'}
        <a href="./#/reservations" class="mr-5 hover:text-gray-900"
          ><span class="text-gray-600">Obecne rezerwacje</span></a
        >
        <a href="./#/archive" class="mr-5 hover:text-gray-900"
          ><span class="text-gray-600">Archiwum</span></a
        >
      {/if}

      {#if b == 'administrator'}
        <a href="./#/accounts" class="mr-5 hover:text-gray-900"
          ><span class="text-gray-600">Konta</span></a
        >
      {/if}
      <a href="./#/rules" class="mr-5 hover:text-gray-900"
        ><span class="text-gray-600">Regulamin</span></a
      >
    </nav>
    {#if a}
      <SignOut />
    {:else}
      <SignInAndOnButtons />
    {/if}
  </div>
</header>
