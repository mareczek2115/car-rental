<script>
  import Modal from '../components/Modal.svelte';
  import {
    isUserLoggedIn,
    userMail,
    header,
    description,
    button,
  } from '../stores';
  import { params } from 'svelte-spa-router';

  const toggleModal = () => {
    const body = document.querySelector('body');
    const modal = document.querySelector('.modal');
    modal.classList.toggle('opacity-0');
    modal.classList.toggle('pointer-events-none');
    body.classList.toggle('modal-active');
  };

  const setMinDate = (
    el,
    date = new Date().toLocaleDateString(),
    initial = true,
    type = 'min'
  ) => {
    if (new Date().toLocaleTimeString().slice(0, -3) > '17:00' && initial) {
      let s = date.split('.').reverse();
      s[2] = parseInt(s[2]) + 1;
      console.log(s.join('-'));
      el.setAttribute(type, s.join('-'));
    } else {
      el.setAttribute(type, date.split('.').reverse().join('-'));
    }
  };

  let car;

  class carID {
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

  const getCarData = async () => {
    if (a.val !== undefined) {
      const res = await fetch('./backend/Car.php', {
        method: 'POST',
        body: JSON.stringify({ id: a.getValue() }),
      });
      const data = await res.json();
      return data;
    }
  };

  let a = new carID(undefined, () => (car = getCarData()));

  params.subscribe(v => {
    if (v) {
      a.setValue(v.id);
    }
  });

  const formatCarName = (brand, model) => {
    return `${brand} ${model}`.toLowerCase().split(' ').join('-');
  };

  const applyForRental = async () => {
    const inputs = Array.from(document.getElementsByTagName('input'));
    const options = Array.from(document.getElementsByTagName('select'));
    const start_date = inputs[0].value;
    const start_hour = options[0].value;
    const end_date = inputs[1].value;
    const end_hour = options[1].value;
    if (inputs.every(v => v.value !== '')) {
      const res = await fetch('./backend/RentCar.php', {
        method: 'POST',
        body: JSON.stringify({
          car_id: a.val,
          user_mail: $userMail,
          start_date,
          start_hour,
          end_date,
          end_hour,
        }),
      });
      const data = await res.json();
      if (data.result === 'success') {
        header.set('Sukces');
        description.set('Pomyślnie złożono zamówienie!');
        button.set('Przejdź dalej');
        toggleModal();
        document.getElementsByName('input').forEach(el => {
          el.val = '';
        });
      }
    } else {
      header.set('Uwaga');
      description.set('Proszę wprowadzić poprawne dane!');
      button.set('Spróbuj jeszcze raz');
      toggleModal();
    }
  };

  const onDateChange = (target, value) => {
    target === 'start-date'
      ? setMinDate(
          document.getElementById('end-date'),
          value.split('-').reverse().join('.'),
          false
        )
      : setMinDate(
          document.getElementById('start-date'),
          value.split('-').reverse().join('.'),
          false,
          'max'
        );
    if (
      document.getElementById('start-date').value ===
      document.getElementById('end-date').value
    ) {
      if (document.getElementById('start-hour').value === '17:00') {
        let date = document.getElementById('start-date').value.split('-');
        date[2] = parseInt(date[2]) + 1;
        document.getElementById('end-date').value = date.join('-');
        setMinDate(
          document.getElementById('end-date'),
          date.reverse().join('.'),
          false
        );
      } else if (
        document.getElementById('start-hour').value >
        document.getElementById('end-hour').value
      ) {
        document.getElementById('start-hour').value = `${parseInt(
          document.getElementById('end-hour').value.split(':')[0]
        )}:00`;
      } else {
        document.getElementById('end-hour').childNodes[0].disabled = true;
        document.getElementById('end-hour').childNodes[1].selected = true;
      }
    } else {
      Array.from(document.getElementById('start-hour').childNodes).forEach(
        v => (v.disabled = false)
      );
      Array.from(document.getElementById('end-hour').childNodes).forEach(
        v => (v.disabled = false)
      );
    }
  };

  const onHourChange = (target, value) => {
    if (
      document.getElementById('start-date').value ===
      document.getElementById('end-date').value
    ) {
      Array.from(document.getElementById('start-hour').childNodes).forEach(
        v => (v.disabled = false)
      );
      Array.from(document.getElementById('end-hour').childNodes).forEach(
        v => (v.disabled = false)
      );
      if (target === 'start-hour') {
        if (value === '17:00') {
          let date = document.getElementById('end-date').value.split('-');
          date[2] = parseInt(date[2]) + 1;
          document.getElementById('end-date').value = date.join('-');
          setMinDate(
            document.getElementById('end-date'),
            date.reverse().join('.'),
            false
          );
        } else {
          Array.from(document.getElementById('end-hour').childNodes).forEach(
            v => {
              if (v.value <= value) v.disabled = true;
            }
          );
          if (document.getElementById('end-hour').value <= value) {
            document.getElementById('end-hour').value = `${
              parseInt(value) + 1
            }:00`;
          }
        }
      } else {
        if (value === '10:00') {
        } else {
          Array.from(document.getElementById('start-hour').childNodes).forEach(
            v => {
              if (v.value >= value) v.disabled = true;
            }
          );
          if (document.getElementById('start-hour').value >= value) {
            document.getElementById('start-hour').value = `${
              parseInt(value) - 1
            }:00`;
          }
        }
      }
    } else {
      setMinDate(
        document.getElementById('end-date'),
        document
          .getElementById('start-date')
          .value.split('-')
          .reverse()
          .join('.'),
        false
      );
    }
  };
</script>

{#await car then car}
  {#if car}
    <section class="text-gray-600 body-font overflow-hidden pb-12">
      <div class="container pt-11 pb-6 mx-auto px-5">
        <div class="lg:w-4/5 mx-auto flex flex-wrap mx-auto">
          <!-- svelte-ignore a11y-missing-attribute -->
          <img
            class="lg:w-1/2 w-full lg:h-auto h-64 object-scale-down rounded"
            src="./assets/car-images/{formatCarName(car.brand, car.model)}.jpg"
          />
          <div class="lg:w-1/2 w-full lg:pl-10 mt-4 lg:mt-0">
            <h1 class="text-gray-900 text-3xl title-font font-medium mb-1">
              {car.brand}
              {car.model}
            </h1>
            <p class="leading-relaxed">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent
              vehicula blandit fermentum. Nam convallis tellus tellus, quis
              suscipit tortor molestie in. Vestibulum ante ipsum primis in
              faucibus orci luctus et ultrices posuere cubilia curae. Vivamus
              rutrum massa a consectetur ultrices.
            </p>
            <div class="flex mt-6" />
            <div class="flex flex-row h-1/6 w-max flex-wrap content-evenly">
              <div class="flex flex-row items-center justify-start w-1/2">
                <p>Skrzynia biegów: {car.transmission}</p>
              </div>
              <div class="flex flex-row items-center justify-start w-1/2">
                <p>Paliwo: {car.fuel_type}</p>
              </div>
              <div class="flex flex-row items-center justify-start w-1/2">
                <p>
                  Średnie spalanie: {car.average_fuel_consumption} l / 100 km
                </p>
              </div>
              <div class="flex flex-row items-center justify-start w-1/2">
                <p>Liczba drzwi: {car.number_of_doors}</p>
              </div>
            </div>
            <div
              class="flex mt-3 items-center pb-5 border-b-2 border-gray-100 mb-5"
            />
            <div class="flex flex-row flex-wrap justify-between items-center">
              {#if $isUserLoggedIn}
                <div class="flex flex-col text-base p-4">
                  <span>Data i godzina wypożyczenia</span>
                  <input
                    use:setMinDate
                    on:change={e => onDateChange('start-date', e.target.value)}
                    type="date"
                    id="start-date"
                    required
                  />
                  <select
                    name="start-hour"
                    id="start-hour"
                    on:change={e => onHourChange('start-hour', e.target.value)}
                    required
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
                </div>
                <div class="flex flex-col text-base p-4">
                  <span>Data i godzina zwrotu</span>
                  <input
                    use:setMinDate
                    on:change={e => onDateChange('end-date', e.target.value)}
                    type="date"
                    id="end-date"
                    required
                  />
                  <select
                    name="end-hour"
                    id="end-hour"
                    on:change={e => onHourChange('end-hour', e.target.value)}
                    required
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
                </div>
              {/if}
              <span class="title-font font-medium text-2xl text-gray-900 p-2"
                >{car.price_per_hour}0 zł / godzina</span
              >
              {#if $isUserLoggedIn}
                <!-- svelte-ignore component-name-lowercase -->
                <button
                  on:click={applyForRental}
                  class="flex ml-auto text-white bg-indigo-500 border-0 p-2 focus:outline-none hover:bg-indigo-600 rounded"
                  >Zgłoś chęć wypożyczenia</button
                >
              {/if}
            </div>
          </div>
        </div>
      </div>
    </section>
  {/if}
{/await}
<Modal
  header={$header}
  description={$description}
  button={$button}
  handleClick={toggleModal}
/>
