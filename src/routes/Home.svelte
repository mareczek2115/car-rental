<script>
  function setImage(name) {
    document.getElementById('image').src = `./assets/car-images/${name}.jpg`;
  }
</script>

<section class="text-gray-600 body-font flex-grow">
  <div class="container px-5 py-4 mx-auto flex flex-wrap flex-col">
    <div class="flex mx-auto flex-wrap mb-10">
      <button
        on:click={e => setImage(e.target.value)}
        value="chevrolet-corvette-c7"
        class="sm:px-6 py-3 w-1/2 sm:w-auto justify-center sm:justify-start border-b-2 border-t-0 border-l-0 border-r-0 title-font font-medium cursor-pointer hover:bg-gray-100 inline-flex items-center leading-none border-green-200 hover:border-green-500 hover:text-gray-900 tracking-wider"
      >
        Chevrolet Corvette
      </button>
      <button
        on:click={e => setImage(e.target.value)}
        value="bmw-x4"
        class="sm:px-6 py-3 w-1/2 sm:w-auto justify-center sm:justify-start border-b-2 border-t-0 border-l-0 border-r-0 title-font font-medium cursor-pointer hover:bg-gray-100 inline-flex items-center leading-none border-green-200 hover:border-green-500 hover:text-gray-900 tracking-wider"
      >
        BMW X4
      </button>
      <button
        on:click={e => setImage(e.target.value)}
        value="audi-a6"
        class="sm:px-6 py-3 w-1/2 sm:w-auto justify-center sm:justify-start border-b-2 border-t-0 border-l-0 border-r-0 title-font font-medium cursor-pointer hover:bg-gray-100 inline-flex items-center leading-none border-green-200 hover:border-green-500 hover:text-gray-900 tracking-wider"
      >
        Audi A6
      </button>
      <button
        on:click={e => setImage(e.target.value)}
        value="mercedes-benz-e"
        class="sm:px-6 py-3 w-1/2 sm:w-auto justify-center sm:justify-start border-b-2 border-t-0 border-l-0 border-r-0 title-font font-medium cursor-pointer hover:bg-gray-100 inline-flex items-center leading-none border-green-200 hover:border-green-500 hover:text-gray-900 tracking-wider"
      >
        Mercedes-Benz E
      </button>
    </div>
    <img
      id="image"
      class="w-1/3 block mx-auto mb-10 object-center rounded"
      alt="Cars"
      src="./assets/car-images/chevrolet-corvette-c7.jpg"
    />
    <div class="flex flex-col text-center w-full">
      <h1 class="text-xl font-medium title-font mb-4 text-gray-900">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </h1>
      <p class="lg:w-2/3 mx-auto leading-relaxed text-base">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas
        maximus orci justo, vitae facilisis dolor lobortis ut. Curabitur dictum,
        quam vitae elementum viverra, erat lorem tincidunt leo, eget ultricies
        turpis tortor et nunc.
      </p>
    </div>
  </div>
</section>
