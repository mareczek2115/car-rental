<script>
  import QrCode from 'svelte-qrcode';

  export let header;
  export let description;
  export let button;
  export let handleClick;
</script>

<div
  class="modal opacity-0 pointer-events-none fixed w-full h-full top-0 left-0 flex items-center justify-center"
>
  <div class="modal-overlay absolute w-full h-full bg-gray-900 opacity-50" />

  <div
    class="modal-container bg-white w-11/12 md:max-w-md mx-auto rounded shadow-lg z-50 overflow-y-auto"
  >
    <div class="modal-content py-4 text-left px-6 flex flex-col">
      <div class="flex justify-between items-center pb-3">
        <p class="text-2xl font-bold">{header}</p>
      </div>

      {#if header !== ''}
        <p>{description}</p>
      {:else}
        <div class="self-center" style="align-self: center;">
          <QrCode value={description} />
        </div>
      {/if}

      <div class="flex justify-end pt-2">
        <button
          on:click={handleClick}
          class="modal-close px-4 bg-indigo-500 p-3 rounded-lg text-white hover:bg-indigo-400"
          >{button}</button
        >
      </div>
    </div>
  </div>
</div>
