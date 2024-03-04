<script>
  import { isUserLoggedIn, user, userMail, accountType } from '../stores';

  const logout = () => {
    isUserLoggedIn.set(false);
    user.set('');
    userMail.set('');
    accountType.set('');
    location.assign('./#/');
  };

  //   export function stopWheel() {
  //     document.getElementById('wheel').remove();
  //   }
</script>

<nav class="md:mr-3 md:ml-4 md:py-1 md:pl-4">
  <p><span class="text-gray-600">Witaj, {$user}</span></p>
</nav>
<button
  on:click={logout}
  class="inline-flex items-center bg-gray-100 border-0 outline-black py-1 px-3 hover:bg-gray-200 rounded text-base mt-4 md:mt-0 text-gray-900"
  >Wyloguj się</button
>
