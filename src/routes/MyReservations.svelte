<!-- svelte-ignore component-name-lowercase -->
<script>
  import {
    isUserLoggedIn,
    user,
    userMail,
    accountType,
    header,
    description,
    button,
  } from '../stores';
  import Modal from '../components/Modal.svelte';
  import { push } from 'svelte-spa-router';

  if (!$isUserLoggedIn) push('/');

  const toggleModal = () => {
    const body = document.querySelector('body');
    const modal = document.querySelector('.modal');
    modal.classList.toggle('opacity-0');
    modal.classList.toggle('pointer-events-none');
    body.classList.toggle('modal-active');
  };

  let reservations;

  class userEmailAddressClass {
    constructor(initVal, onChange) {
      this.val = initVal;
      this.onChange = onChange;
      this.getValue = this.getValue.bind(this);
      this.setValue = this.setValue.bind(this);
    }
    getValue() {
      return this.val;
    }
    setValue(value) {
      this.val = value;
      this.onChange();
    }
  }

  let now = Date.now();
  let date = new Date(now);
  let dateString = date.toLocaleString().replace(/\s/gi, '');
  let formattedNowString =
    dateString.split(',')[0].split('.').reverse().join('-') +
    ' ' +
    dateString.split(',')[1];
  console.log(formattedNowString);

  const myReservations = async () => {
    if (a.val !== undefined) {
      const res = await fetch('./backend/MyReservations.php', {
        method: 'POST',
        body: JSON.stringify({ userEmail: a.val }),
      });
      const [data] = await res.json();
      return data;
    }
  };

  const cancelReservation = async id => {
    const res = await fetch('./backend/CancelReservation.php', {
      method: 'POST',
      body: JSON.stringify({ id }),
    });
    const data = await res.json();
    if (data.result === 'success') {
      reservations = myReservations();
    }
  };

  let handleClick = () => {
    isUserLoggedIn.set(false);
    user.set('');
    userMail.set('');
    accountType.set('');
    toggleModal();
    location.assign('./#/');
  };

  const returnCar = async (id, date_of_expected_return) => {
    const res = await fetch('./backend/ReturnCar.php', {
      method: 'POST',
      body: JSON.stringify({ id, date_of_expected_return }),
    });
    const data = await res.json();
    if (data.result === 'success') {
      reservations = myReservations();
    } else {
      handleClick = () => {
        isUserLoggedIn.set(false);
        user.set('');
        userMail.set('');
        accountType.set('');
        toggleModal();
        location.assign('./#/');
      };
      header.set('Konto zablokowane');
      description.set(
        'Twoje konto zostało zablokowane z powodu zbyt późnego zwrotu auta. Decyzję o odblokowaniu konta podejmie administrator.'
      );
      button.set('OK');
      toggleModal();
    }
  };

  let a = new userEmailAddressClass(
    undefined,
    () => (reservations = myReservations())
  );

  userMail.subscribe(v => {
    if (v) {
      a.setValue(v);
    }
  });
</script>

<section class="text-gray-600 body-font overflow-y-auto py-12">
  <div
    class="text-2xl font-medium text-gray-900 title-font mb-2 px-5 w-full flex justify-around"
  >
    <h2>Rezerwacje oczekujące</h2>
    <h2>Rezerwacje aktywne</h2>
    <h2>Rezerwacje archiwalne</h2>
  </div>
  <div class="container px-5 py-12 mx-auto flex flex-row">
    <div class="-my-8 divide-y-2 divide-gray-100 w-1/3 m-5">
      {#await reservations then reservations}
        {#each reservations.awaiting_reservations as reservation}
          <div
            class="py-5 flex flex-wrap md:flex-nowrap border-t-2 border-b-2 bg-yellow-200 mt-4"
          >
            <div class="md:flex-grow flex flex-col items-start mx-5">
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Auto: {reservation.brand}
                {reservation.model}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Wypożyczenie: {`${reservation.date_of_rent_start
                  .slice(0, 10)
                  .split('-')
                  .reverse()
                  .join('-')} ${reservation.date_of_rent_start.slice(11, -3)}`}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Zwrot: {`${reservation.date_of_expected_return
                  .slice(0, 10)
                  .split('-')
                  .reverse()
                  .join('-')} ${reservation.date_of_expected_return.slice(
                  11,
                  -3
                )}`}
              </h2>
              <button
                on:click={() => cancelReservation(reservation.id)}
                class="inline-flex border-2 border-black py-1 px-3 hover:bg-yellow-300 rounded text-base mt-4 md:mt-0 text-black focus:border-black"
                >Anuluj</button
              >
            </div>
          </div>
        {/each}
      {/await}
    </div>
    <div class="-my-8 divide-y-2 divide-gray-100 w-1/3 m-5">
      {#await reservations then reservations}
        {#each reservations.active_reservations as reservation}
          <div
            class="py-5 flex flex-wrap md:flex-nowrap border-t-2 border-b-2 bg-green-200 mt-4"
          >
            <div class="md:flex-grow flex flex-col items-start mx-5">
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Auto: {reservation.brand}
                {reservation.model}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Wypożyczenie: {`${reservation.date_of_rent_start
                  .slice(0, 10)
                  .split('-')
                  .reverse()
                  .join('-')} ${reservation.date_of_rent_start.slice(11, -3)}`}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Zwrot: {`${reservation.date_of_expected_return
                  .slice(0, 10)
                  .split('-')
                  .reverse()
                  .join('-')} ${reservation.date_of_expected_return.slice(
                  11,
                  -3
                )}`}
              </h2>
              <div class="flex flex-row justify-start w-full">
                {#if formattedNowString > reservation.date_of_rent_start}
                  <button
                    on:click={() => {
                      header.set('');
                      description.set(
                        `Auto: ${reservation.brand} ${reservation.model}\nData wypozyczenia: ${reservation.date_of_rent_start}\nData zwrotu: ${reservation.date_of_expected_return}`
                      );
                      button.set('OK');
                      handleClick = () => toggleModal();
                      toggleModal();
                    }}
                    class="inline-flex border-2 border-black py-1 px-3 hover:bg-green-300 rounded text-base mt-4 md:mt-0 text-black focus:border-black mr-4"
                    >Kod QR rezerwacji</button
                  >
                {/if}
                <button
                  on:click={() =>
                    returnCar(
                      reservation.id,
                      reservation.date_of_expected_return
                    )}
                  class="inline-flex border-2 border-black py-1 px-3 hover:bg-green-300 rounded text-base mt-4 md:mt-0 text-black focus:border-black"
                  >Zwróć samochód</button
                >
              </div>
            </div>
          </div>
        {/each}
      {/await}
    </div>
    <div class="-my-8 divide-y-2 divide-gray-100 w-1/3 m-5">
      {#await reservations then reservations}
        {#each reservations.archival_reservations as reservation}
          <div
            class="py-5 flex flex-wrap md:flex-nowrap border-t-2 border-b-2 bg-red-200 mt-4"
          >
            <div class="md:flex-grow flex flex-col items-start mx-5">
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Auto: {reservation.brand}
                {reservation.model}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Wypożyczenie: {`${reservation.date_of_rent
                  .slice(0, 10)
                  .split('-')
                  .reverse()
                  .join('-')} ${reservation.date_of_rent.slice(11, -3)}`}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Zwrot: {`${reservation.date_of_return
                  .slice(0, 10)
                  .split('-')
                  .reverse()
                  .join('-')} ${reservation.date_of_return.slice(11, -3)}`}
              </h2>
            </div>
          </div>
        {/each}
      {/await}
    </div>
  </div>
</section>

<Modal
  header={$header}
  description={$description}
  button={$button}
  {handleClick}
/>
