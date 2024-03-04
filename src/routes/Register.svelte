<script>
  import { header, description, button } from '../stores';
  import Modal from '../components/Modal.svelte';

  let headerText;
  let descriptionText;
  let buttonText;

  header.subscribe(v => {
    headerText = v;
  });
  description.subscribe(v => {
    descriptionText = v;
  });
  button.subscribe(v => {
    buttonText = v;
  });

  let registered = false;

  const toggleModal = () => {
    const body = document.querySelector('body');
    const modal = document.querySelector('.modal');
    modal.classList.toggle('opacity-0');
    modal.classList.toggle('pointer-events-none');
    body.classList.toggle('modal-active');
  };

  const register = async () => {
    const password = document.getElementById('password').value;
    const repeatPassword = document.getElementById('repeat-password').value;

    const name = document.getElementById('name').value;
    const surname = document.getElementById('surname').value;
    const emailAddress = document.getElementById('email-address').value;

    const res = await fetch('./backend/Register.php', {
      method: 'POST',
      body: JSON.stringify({
        name,
        surname,
        emailAddress,
        password,
        repeatPassword,
      }),
    });
    const data = await res.json();

    switch (data.result) {
      case 'success':
        header.set('Konto utworzone!');
        description.set(
          'Konto zostało utworzone. Poczekaj, aż administrator aktywuje Twoje konto.'
        );
        button.set('OK');
        registered = true;
        break;
      case 'empty_password':
        header.set('Błąd!');
        description.set('Hasło nie może być puste!');
        button.set('Spróbuj ponownie');
        break;
      case 'passwords_unmatch':
        header.set('Błąd!');
        description.set('Podane hasła nie są zgodne!');
        button.set('Spróbuj ponownie');
      case 'wrong_email':
        header.set('Błąd!');
        description.set('Niepoprawny adres email!');
        button.set('Spróbuj ponownie');
        break;
      case 'incomplete_data':
        header.set('Błąd!');
        description.set('Dane nie są kompletne!');
        button.set('Spróbuj ponownie');
        break;
      default:
        header.set('Błąd!');
        description.set('Podane nieprawidłowe dane!');
        button.set('Spróbuj ponownie');
        break;
    }
    toggleModal();
  };

  const handleClick = () => {
    toggleModal();
    if (registered) location.assign('./#/login');
  };

  document.onkeyup = e => {
    if (e.code === 'Enter') register();
  };
</script>

<div class="flex justify-center items-center w-full h-5/6">
  <form class="w-full max-w-lg">
    <div class="flex flex-wrap -mx-3 mb-2">
      <div class="w-full md:w-1/2 px-3 md:mb-0">
        <label
          class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
          for="name"
        >
          Imię
        </label>
        <input
          required
          class="appearance-none block w-full bg-gray-200 text-gray-700 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white"
          id="name"
          type="text"
          placeholder="Jan"
          name="name"
        />
      </div>
      <div class="w-full md:w-1/2 px-3">
        <label
          class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
          for="surname"
        >
          Nazwisko
        </label>
        <input
          required
          class="appearance-none block w-full bg-gray-200 text-gray-700 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
          id="surname"
          type="text"
          placeholder="Kowalski"
          name="surname"
        />
      </div>
    </div>
    <div class="flex flex-wrap -mx-3 mb-2">
      <div class="w-full px-3">
        <label
          class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
          for="email-address"
        >
          Adres e-mail
        </label>
        <input
          required
          class="appearance-none block w-full bg-gray-200 text-gray-700 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
          id="email-address"
          type="email"
          placeholder="kowalski@poczta.pl"
          name="email-address"
        />
      </div>
    </div>
    <div class="flex flex-wrap -mx-3 mb-2">
      <div class="w-full px-3">
        <label
          class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
          for="password"
        >
          Hasło
        </label>
        <input
          required
          class="appearance-none block w-full bg-gray-200 text-gray-700 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
          id="password"
          type="password"
          placeholder="******************"
          name="password"
        />
      </div>
    </div>
    <div class="flex flex-wrap -mx-3 mb-8">
      <div class="w-full px-3">
        <label
          class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
          for="repeat-password"
        >
          Powtórz hasło
        </label>
        <input
          required
          class="appearance-none block w-full bg-gray-200 text-gray-700 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
          id="repeat-password"
          type="password"
          placeholder="******************"
          name="repeat-password"
        />
      </div>
    </div>
    <div class="flex items-center justify-between w-full">
      <!-- svelte-ignore component-name-lowercase -->
      <button
        on:click={register}
        class="w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        type="button"
      >
        Zarejestruj się
      </button>
    </div>
  </form>
</div>
<Modal
  header={headerText}
  description={descriptionText}
  button={buttonText}
  {handleClick}
/>
