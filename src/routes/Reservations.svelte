<!-- svelte-ignore component-name-lowercase -->
<script>
  import { push } from 'svelte-spa-router';
  import {
    accountType,
    isUserLoggedIn,
    header,
    description,
    button,
  } from '../stores';
  import Modal from '../components/Modal.svelte';

  if (!$isUserLoggedIn || accountType === 'klient') push('/');

  let reservations;

  let awaitingOrder = 'awaiting_reservations.id ASC';
  let activeOrder = 'active_reservations.id ASC';

  let handleClick;

  const toggleModal = () => {
    const body = document.querySelector('body');
    const modal = document.querySelector('.modal');
    modal.classList.toggle('opacity-0');
    modal.classList.toggle('pointer-events-none');
    body.classList.toggle('modal-active');
  };

  const handleAwaitingReservation = async (id, type) => {
    const res = await fetch('./backend/HandleAwaitingReservations.php', {
      method: 'POST',
      body: JSON.stringify({ id, type }),
    });
    const data = await res.json();
    if (data.result === 'success') reservations = getPendingReservations();
    else alert('error');
  };

  const getPendingReservations = async (
    awaitingOrder = 'awaiting_reservations.id ASC',
    activeOrder = 'active_reservations.id ASC'
  ) => {
    const res = await fetch('./backend/PendingReservations.php', {
      method: 'POST',
      body: JSON.stringify({ awaitingOrder, activeOrder }),
    });
    const [data] = await res.json();
    return data;
  };

  const endTheRent = async (id, date_of_expected_return) => {
    const res = await fetch('./backend/ReturnCar.php', {
      method: 'POST',
      body: JSON.stringify({ id, date_of_expected_return }),
    });
    const data = await res.json();
    if (data.result === 'success')
      reservations = getPendingReservations(awaitingOrder, activeOrder);
    else {
      header.set('!');
      description.set(
        'Rezerwacja została zakończona po czasie. Konto wypożyczającego zostało zablokowane.'
      );
      button.set('OK');
      handleClick = () => toggleModal();
      toggleModal();
    }

    reservations = getPendingReservations();
  };

  const sortFormat = value => {
    let t = value.split(' ');
    t[0] = t[0].replace(/-/g, '_');
    t[1] = t[1].toUpperCase();
    return t.join(' ');
  };

  const changeDate = (type, id) => {
    let date;
    const new_date = document.getElementById(`${type}-date-${id}`).value;
    const new_hour = document.getElementById(`${type}-hour-${id}`).value;
    console.log(new_date);
    if (new_date !== '') {
      header.set('!');
      description.set('Zmienić datę?');
      button.set('OK');
      handleClick = async () => {
        date = `${new_date} ${new_hour}:00`;
        const res = await fetch('./backend/ChangeReservationDate.php', {
          method: 'POST',
          body: JSON.stringify({
            id,
            date,
            table: type.split('-')[0],
            column: type.split('-')[1],
          }),
        });
        const data = await res.json();
        if (data.result === 'success') {
          reservations = getPendingReservations();
        }
        toggleModal();
      };
    } else {
      header.set('Brak danych');
      description.set('Nie wprowadzono nowej daty!');
      button.set('OK');
      handleClick = () => toggleModal();
    }
    toggleModal();
  };

  reservations = getPendingReservations();
</script>

<!-- svelte-ignore a11y-missing-attribute -->

<section class="text-gray-600 body-font overflow-y-auto py-12">
  <div
    class="text-2xl font-medium text-gray-900 title-font mb-2 px-5 w-full flex justify-around"
  >
    <h2>Rezerwacje oczekujące</h2>
    <h2>Rezerwacje aktywne</h2>
  </div>
  <div
    class="text-2xl font-medium text-gray-900 title-font mb-2 px-5 w-full flex justify-around"
  >
    <div>
      <select
        name="awaiting"
        id="awaiting"
        on:change={e => {
          awaitingOrder = sortFormat(e.target.value);
          reservations = getPendingReservations(awaitingOrder, activeOrder);
        }}
      >
        <option value="brand asc">Według auta, rosnąco</option>
        <option value="brand desc">Według auta, malejąco</option>
        <option value="surname asc">Według wypożyczającego, rosnąco</option>
        <option value="surname desc">Według wypożyczającego, malejąco</option>
        <option value="date-of-rent-start asc"
          >Według daty wypożyczenia, rosnąco</option
        >
        <option value="date-of-rent-start desc"
          >Według daty wypożyczenia, malejąco</option
        >
        <option value="date-of-expected-return asc"
          >Według daty zwrotu, rosnąco</option
        >
        <option value="date-of-expected-return desc"
          >Według daty zwrotu, malejąco</option
        >
      </select>
    </div>
    <div>
      <select
        name="active"
        id="active"
        on:change={e => {
          activeOrder = sortFormat(e.target.value);
          reservations = getPendingReservations(awaitingOrder, activeOrder);
        }}
      >
        <option value="brand asc">Według auta, rosnąco</option>
        <option value="brand desc">Według auta, malejąco</option>
        <option value="surname asc">Według wypożyczającego, rosnąco</option>
        <option value="surname desc">Według wypożyczającego, malejąco</option>
        <option value="date-of-rent-start asc"
          >Według daty wypożyczenia, rosnąco</option
        >
        <option value="date-of-rent-start desc"
          >Według daty wypożyczenia, malejąco</option
        >
        <option value="date-of-expected-return asc"
          >Według daty zwrotu, rosnąco</option
        >
        <option value="date-of-expected-return desc"
          >Według daty zwrotu, malejąco</option
        >
      </select>
    </div>
  </div>
  <div class="container px-5 py-12 mx-auto flex flex-row">
    <div class="-my-8 divide-y-2 divide-gray-100 w-1/2 m-5">
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
                Wypożyczający: {reservation.account}
              </h2>
              <div class="flex flex-row w-full">
                <h2
                  class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
                >
                  Wypożyczenie: {`${reservation.date_of_rent_start
                    .slice(0, 10)
                    .split('-')
                    .reverse()
                    .join('-')} ${reservation.date_of_rent_start.slice(
                    11,
                    -3
                  )}`}
                </h2>
                <form class="mx-4">
                  <input
                    type="date"
                    name="awaiting-start-date-{reservation.id}"
                    id="awaiting-start-date-{reservation.id}"
                  />
                  <select
                    name="awaiting-start-hour-{reservation.id}"
                    id="awaiting-start-hour-{reservation.id}"
                  >
                    <option value="10:00">10:00</option>
                    <option value="11:00">11:00</option>
                    <option value="12:00">12:00</option>
                    <option value="13:00">13:00</option>
                    <option value="14:00">14:00</option>
                    <option value="15:00">15:00</option>
                    <option value="16:00">16:00</option>
                    <option value="17:00">17:00</option>
                  </select>
                </form>
              </div>
              <div class="flex flex-row w-full">
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
                <form class="mx-4">
                  <input
                    type="date"
                    name="awaiting-end-date-{reservation.id}"
                    id="awaiting-end-date-{reservation.id}"
                  />
                  <select
                    name="awaiting-end-hour-{reservation.id}"
                    id="awaiting-end-hour-{reservation.id}"
                  >
                    <option value="10:00">10:00</option>
                    <option value="11:00">11:00</option>
                    <option value="12:00">12:00</option>
                    <option value="13:00">13:00</option>
                    <option value="14:00">14:00</option>
                    <option value="15:00">15:00</option>
                    <option value="16:00">16:00</option>
                    <option value="17:00">17:00</option>
                  </select>
                </form>
              </div>
              <div class="flex flex-row justify-start">
                <button
                  on:click={() =>
                    handleAwaitingReservation(reservation.id, 'accept')}
                  class="inline-flex border-2 border-black py-1 px-3 hover:bg-yellow-300 rounded text-base mt-4 md:mt-0 text-black focus:border-black"
                  >Akceptuj</button
                >
                <button
                  on:click={() =>
                    handleAwaitingReservation(reservation.id, 'reject')}
                  class="inline-flex border-2 border-black py-1 px-3 hover:bg-yellow-300 rounded text-base mt-4 md:mt-0 text-black mx-4 focus:border-black"
                  >Odrzuć</button
                >
                <button
                  on:click={() => changeDate('awaiting-start', reservation.id)}
                  class="inline-flex border-2 border-black py-1 px-3 hover:bg-yellow-300 rounded text-base mt-4 md:mt-0 text-black focus:border-black"
                  >Zmień datę wypożyczenia</button
                >
                <button
                  on:click={() => changeDate('awaiting-end', reservation.id)}
                  class="inline-flex border-2 border-black py-1 px-3 hover:bg-yellow-300 rounded text-base mt-4 md:mt-0 text-black mx-4 focus:border-black"
                  >Zmień datę zwrotu</button
                >
              </div>
            </div>
          </div>
        {/each}
      {/await}
    </div>
    <div class="-my-8 divide-y-2 divide-gray-100 w-1/2 m-5">
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
                Wypożyczający: {reservation.account}
              </h2>
              <div class="flex flex-row w-full">
                <h2
                  class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
                >
                  Wypożyczenie: {`${reservation.date_of_rent_start
                    .slice(0, 10)
                    .split('-')
                    .reverse()
                    .join('-')} ${reservation.date_of_rent_start.slice(
                    11,
                    -3
                  )}`}
                </h2>
                <form action="" class="mx-4">
                  <input
                    type="date"
                    name="active-start-date-{reservation.id}"
                    id="active-start-date-{reservation.id}"
                  />
                  <select
                    name="active-start-hour-{reservation.id}"
                    id="active-start-hour-{reservation.id}"
                  >
                    <option value="10:00">10:00</option>
                    <option value="11:00">11:00</option>
                    <option value="12:00">12:00</option>
                    <option value="13:00">13:00</option>
                    <option value="14:00">14:00</option>
                    <option value="15:00">15:00</option>
                    <option value="16:00">16:00</option>
                    <option value="17:00">17:00</option>
                  </select>
                </form>
              </div>
              <div class="flex flex-row w-full">
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
                <form action="" class="mx-4">
                  <input
                    type="date"
                    name="active-end-date-{reservation.id}"
                    id="active-end-date-{reservation.id}"
                  />
                  <select
                    name="active-end-hour-{reservation.id}"
                    id="active-end-hour-{reservation.id}"
                  >
                    <option value="10:00">10:00</option>
                    <option value="11:00">11:00</option>
                    <option value="12:00">12:00</option>
                    <option value="13:00">13:00</option>
                    <option value="14:00">14:00</option>
                    <option value="15:00">15:00</option>
                    <option value="16:00">16:00</option>
                    <option value="17:00">17:00</option>
                  </select>
                </form>
              </div>
              <div class="flex flex-row justify-start w-full">
                <button
                  on:click={() =>
                    endTheRent(
                      reservation.id,
                      reservation.date_of_expected_return
                    )}
                  class="inline-flex border-2 border-black py-1 px-3 hover:bg-green-300 rounded text-base mt-4 md:mt-0 text-black focus:border-black"
                  >Zakończ wypożyczenie</button
                >
                <button
                  on:click={() => changeDate('active-start', reservation.id)}
                  class="inline-flex border-2 border-black py-1 px-3 hover:bg-green-300 rounded text-base mt-4 md:mt-0 text-black focus:border-black mx-4"
                  >Zmień datę wypożyczenia</button
                >
                <button
                  on:click={() => changeDate('active-end', reservation.id)}
                  class="inline-flex border-2 border-black py-1 px-3 hover:bg-green-300 rounded text-base mt-4 md:mt-0 text-black focus:border-black"
                  >Zmień datę zwrotu</button
                >
              </div>
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
