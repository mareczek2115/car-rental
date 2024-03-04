<script>
  import {
    header,
    description,
    button,
    isUserLoggedIn,
    user,
    userMail,
    accountType,
  } from '../stores';
  import Modal from '../components/Modal.svelte';

  const toggleModal = () => {
    const body = document.querySelector('body');
    const modal = document.querySelector('.modal');
    modal.classList.toggle('opacity-0');
    modal.classList.toggle('pointer-events-none');
    body.classList.toggle('modal-active');
  };

  const login = async () => {
    const emailAddress = document.getElementById('email-address').value;
    const password = document.getElementById('password').value;
    const res = await fetch('./backend/Login.php', {
      method: 'POST',
      credentials: 'include',
      body: JSON.stringify({
        emailAddress,
        password,
      }),
    });
    const data = await res.json();
    if (data.result === 'success') {
      isUserLoggedIn.set(true);
      user.set(data.user);
      userMail.set(data.user_email);
      accountType.set(data.account_type);
      location.assign('./#/');
    } else if (data.result === 'banned') {
      header.set('Konto zablokowane');
      description.set(
        'Twoje konto zostało zablokowane przez administratora, najprawdopodobniej za niezwrócenie auta w terminie. Gdy konto zostanie odblokowane, otrzymasz maila informującego o odblokowaniu konta.'
      );
      button.set('Zamknij');
      toggleModal();
    } else if (data.result === 'inactive') {
      header.set('Konto nieaktywne');
      description.set(
        'Konto jest nieaktywne. Poczekaj, aż administrator aktywuje twoje konto.'
      );
      button.set('Zamknij');
      toggleModal();
    } else {
      header.set('Błąd');
      description.set('Podany adres email lub hasło jest nieprawidłowe!');
      button.set('Spróbuj ponownie');
      toggleModal();
    }
  };

  document.onkeyup = e => {
    if (e.code === 'Enter') login();
  };
</script>

<div class="flex justify-center items-center w-full h-5/6">
  <form>
    <div class="w-full max-w-xs">
      <form
        class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 flex flex-col items-center justify-between"
      >
        <div class="mb-4">
          <label
            class="block text-gray-700 text-sm font-bold mb-2"
            for="email-address"
          >
            Adres e-mail
          </label>
          <input
            required
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            id="email-address"
            type="email"
            placeholder="Adres e-mail"
            name="email-address"
          />
        </div>
        <div class="mb-6">
          <label
            class="block text-gray-700 text-sm font-bold mb-2"
            for="password"
          >
            Hasło
          </label>
          <input
            required
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
            id="password"
            type="password"
            placeholder="******************"
            name="password"
          />
        </div>
        <div class="flex items-center justify-between mb-2">
          <!-- svelte-ignore component-name-lowercase -->
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            type="button"
            on:click={login}
          >
            Zaloguj się
          </button>
        </div>
        <div>
          <a
            class="inline-block align-baseline font-bold text-sm"
            href="./#/reset-password"
          >
            <span class="text-gray-900">Zapomniałeś hasła?</span>
          </a>
        </div>
      </form>
    </div>
  </form>
</div>
<Modal
  header={$header}
  description={$description}
  button={$button}
  handleClick={toggleModal}
/>
