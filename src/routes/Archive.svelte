<!-- svelte-ignore a11y-missing-attribute -->
<script>
  import { push } from 'svelte-spa-router';

  import { accountType, isUserLoggedIn } from '../stores';

  if (!$isUserLoggedIn || accountType === 'klient') push('/');

  // let order = 'archival_reservations.id ASC'

  const getArchivalReservations = async (
    order = 'archival_reservations.id ASC'
  ) => {
    const res = await fetch('./backend/Archive.php', {
      method: 'POST',
      body: JSON.stringify({ order }),
    });
    const data = await res.json();
    return data;
  };

  const sortFormat = value => {
    let t = value.split(' ');
    t[0] = t[0].replace(/-/g, '_');
    t[1] = t[1].toUpperCase();
    return t.join(' ');
  };

  let archive = getArchivalReservations();
</script>

<section class="text-gray-600 body-font overflow-y-auto py-12">
  <div class="flex flex-col items-center">
    <h2 class="text-2xl font-medium text-gray-900 title-font mb-2 px-5">
      Rezerwacje archiwalne
    </h2>
  </div>
  <div
    class="text-2xl font-medium text-gray-900 title-font mb-2 px-5 w-full flex justify-around"
  >
    <select
      name="archive"
      id="archive"
      on:change={e => {
        archive = getArchivalReservations(sortFormat(e.target.value));
      }}
    >
      <option value="brand asc">Według auta, rosnąco</option>
      <option value="brand desc">Według auta, malejąco</option>
      <option value="surname asc">Według wypożyczającego, rosnąco</option>
      <option value="surname desc">Według wypożyczającego, malejąco</option>
      <option value="date-of-rent asc">Według daty wypożyczenia, rosnąco</option
      >
      <option value="date-of-rent desc"
        >Według daty wypożyczenia, malejąco</option
      >
      <option value="date-of-return asc">Według daty zwrotu, rosnąco</option>
      <option value="date-of-return desc">Według daty zwrotu, malejąco</option>
    </select>
  </div>
  <div class="container px-5 py-10 mx-auto">
    <div class="-my-8 divide-y-2 divide-gray-100 flex flex-col items-center">
      {#await archive then archive}
        {#each archive as archive}
          <div
            class="py-5 flex flex-wrap md:flex-nowrap border-t-2 border-b-2 bg-red-200 mt-4 w-1/2"
          >
            <div class="md:flex-grow flex flex-col items-start mx-5">
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Auto: {archive.brand}
                {archive.model}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Wypożyczający: {archive.account}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Wypożyczenie: {`${archive.date_of_rent
                  .slice(0, 10)
                  .split('-')
                  .reverse()
                  .join('-')} ${archive.date_of_rent.slice(11, -3)}`}
              </h2>
              <h2
                class="text-xl font-medium text-gray-900 title-font mb-2 flex justify-center"
              >
                Zwrot: {`${archive.date_of_return
                  .slice(0, 10)
                  .split('-')
                  .reverse()
                  .join('-')} ${archive.date_of_return.slice(11, -3)}`}
              </h2>
            </div>
          </div>
        {/each}
      {/await}
    </div>
  </div>
</section>
