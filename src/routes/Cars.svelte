<script>
  import { cars } from '../stores';

  let a;

  cars.subscribe(v => {
    a = v;
  });

  const getCars = async () => {
    const res = await fetch('./backend/Cars.php');
    const data = res.json();
    cars.set(data);
    return data;
  };

  const formatCarName = (brand, model) => {
    return `${brand} ${model}`.toLowerCase().split(' ').join('-');
  };

  let carList = getCars();
</script>

<section class="text-gray-600 body-font">
  <div class="container px-8 py-11">
    <div class="flex flex-wrap -m-4 justify-center">
      {#await carList}
        <div id="wheel">
          <div
            style="border-top-color:transparent"
            class="w-6 h-6 border-4 border-green-500 border-solid rounded-full animate-spin"
          />
        </div>
      {:then cars}
        {#each cars as car}
          <div class="lg:w-1/4 md:w-1/2 p-4 w-full">
            <!-- svelte-ignore a11y-missing-attribute -->
            <a class="block relative h-48 rounded overflow-hidden">
              <img
                alt="ecommerce"
                class="object-cover object-center w-full h-full block"
                src="./assets/car-images/{formatCarName(
                  car.brand,
                  car.model
                )}.jpg"
              />
            </a>
            <div class="mt-4">
              <a href="./#/cars/{car.id}"
                ><h2 class="text-gray-900 title-font text-lg font-medium">
                  {car.brand}
                  {car.model}
                </h2></a
              >
            </div>
          </div>
        {/each}
      {/await}
    </div>
  </div>
</section>
