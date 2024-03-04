<!-- svelte-ignore a11y-label-has-associated-control -->
<script>
  import { push } from 'svelte-spa-router';
  import { accountType, header, description, button } from '../stores';
  import Modal from '../components/Modal.svelte';

  if ($accountType !== 'administrator') push('/');

  let a, b, c;

  header.subscribe(v => (a = v));
  description.subscribe(v => (b = v));
  button.subscribe(v => (c = v));

  const toggleModal = () => {
    const body = document.querySelector('body');
    const modal = document.querySelector('.modal');
    modal.classList.toggle('opacity-0');
    modal.classList.toggle('pointer-events-none');
    body.classList.toggle('modal-active');
  };

  const allAccounts = [];
  let accountTypeId = [];
  let accountStatusId = [];

  const getAccounts = async () => {
    const res = await fetch('./backend/Accounts.php');
    const data = await res.json();
    allAccounts.push(...data);
    return data;
  };

  const changeAccountType = (id, e) => {
    e.target.parentNode.parentNode.classList.remove('border-gray-200');
    e.target.parentNode.parentNode.classList.add('border-gray-600');
    if (accountTypeId.some(v => v.id === id)) {
      accountTypeId = accountTypeId.filter(v => v.id !== id);
    }
    accountTypeId.push({ id, accountType: e.target.value });
  };

  const changeAccountStatus = (id, accountStatus, e) => {
    e.target.parentNode.parentNode.parentNode.classList.remove(
      'border-gray-200'
    );
    e.target.parentNode.parentNode.parentNode.classList.add('border-gray-600');
    if (accountStatusId.some(v => v.id === id)) {
      accountStatusId = accountStatusId.filter(v => v.id !== id);
    } else accountStatusId.push({ id, accountStatus });
  };

  const saveChanges = async () => {
    if (accountTypeId.length > 0 || accountStatusId.length > 0) {
      const t = { account_type: [], account_status: [] };
      accountTypeId.forEach(v => {
        t.account_type.push({
          email_address: allAccounts[v.id].email_address,
          account_type: v.accountType,
        });
      });
      accountStatusId.forEach(v => {
        t.account_status.push({
          email_address: allAccounts[v.id].email_address,
          account_status: v.accountStatus,
        });
      });
      const res = await fetch('./backend/ChangeAccountData.php', {
        method: 'POST',
        body: JSON.stringify(t),
      });
      const data = await res.json();
      if (data.result === 'success') {
        accountStatusId = [];
        accountTypeId = [];
        header.set('Sukces');
        description.set('Zaktualizowano użytkowników');
        button.set('OK');
        toggleModal();
      }
    }
  };

  const handleClick = () => {
    toggleModal();
    accounts = getAccounts();
  };

  let accounts = getAccounts();
</script>

<section class="text-gray-600 body-font flex flex-col items-center pb-8">
  <div class="container px-5 pt-11 pb-6 mx-auto">
    <div class="flex flex-wrap -m-2">
      {#await accounts then accounts}
        {#each accounts as account, i}
          <div class="p-2 lg:w-1/3 md:w-1/2 w-full">
            <div
              class="h-full flex items-center border-gray-200 border p-4 rounded-lg {account.account_status ===
              'inactive'
                ? 'bg-indigo-100'
                : account.account_status === 'banned'
                ? 'bg-red-100'
                : ''}"
            >
              {#if account.account_type === 'administrator'}
                <div
                  class="w-16 h-16 bg-gray-200 object-cover object-center rounded-full mr-4 flex flex-row justify-center items-center"
                >
                  <img
                    alt="Administrator"
                    class="w-11 h-11"
                    src="./assets/icons/administrator.png"
                  />
                </div>
              {:else if account.account_type === 'moderator'}
                <div
                  class="w-16 h-16 bg-gray-200 object-cover object-center rounded-full mr-4 flex flex-row justify-center items-center"
                >
                  <img
                    alt="Moderator"
                    class="w-11 h-11"
                    src="./assets/icons/moderator.png"
                  />
                </div>
              {:else}
                <div
                  class="w-16 h-16 bg-gray-200 object-cover object-center rounded-full mr-4 flex flex-row justify-center items-center"
                >
                  <img
                    alt="Klient"
                    class="w-7 h-11"
                    src="./assets/icons/client-1.png"
                  />
                </div>
              {/if}
              <div class="flex-grow">
                <h2 class="text-gray-900 title-font font-medium">
                  {account.name} | {account.email_address}
                </h2>
                <p class="text-gray-500">
                  {account.account_type.charAt(0).toUpperCase() +
                    account.account_type.slice(1)}
                  {#if account.account_status === 'inactive'}
                    | Nieaktywny
                  {:else if account.account_status === 'banned'}
                    | Zablokowany
                  {/if}
                </p>
              </div>
              {#if account.account_status === 'inactive'}
                <div class="flex flex-row justify-start content-end w-1/3">
                  <label>Aktywuj konto</label>
                  <input
                    on:click={e => changeAccountStatus(i, 'active', e)}
                    class="mx-2"
                    type="checkbox"
                    id={i}
                  />
                </div>
              {:else if account.account_status === 'banned'}
                <div class="flex flex-row justify-start content-end w-1/3">
                  <label>Odblokuj konto</label>
                  <input
                    on:click={e => changeAccountStatus(i, 'active', e)}
                    class="mx-2"
                    type="checkbox"
                    id={i}
                  />
                </div>
              {:else}
                <div
                  class="flex flex-col {account.account_type !== 'administrator'
                    ? 'w-1/3'
                    : ''}"
                >
                  {#if account.account_type === 'moderator'}
                    <select
                      name="rank"
                      on:change={e => changeAccountType(i, e)}
                      id={i}
                    >
                      <option value="moderator" selected>Moderator</option>
                      <option value="klient">Klient</option>
                    </select>
                  {:else if account.account_type === 'klient'}
                    <select
                      name="rank"
                      on:change={e => changeAccountType(i, e)}
                      id={i}
                    >
                      <option value="moderator">Moderator</option>
                      <option value="klient" selected>Klient</option>
                    </select>
                  {/if}
                  {#if account.account_type !== 'administrator'}
                    <div class="flex flex-row justify-between">
                      <label>Zablokuj konto</label>
                      <input
                        on:click={e => changeAccountStatus(i, 'banned', e)}
                        type="checkbox"
                        id={i}
                      />
                    </div>
                  {/if}
                </div>
              {/if}
            </div>
          </div>
        {/each}
      {/await}
    </div>
  </div>
  <!-- svelte-ignore component-name-lowercase -->
  <button
    on:click={saveChanges}
    class="inline-flex items-center bg-gray-100 border-0 outline-black py-1 px-3 hover:bg-gray-200 rounded text-base mt-4 md:mt-0 text-gray-900"
    >Zatwierdź zmiany</button
  >
</section>
<Modal header={a} description={b} button={c} {handleClick} />
