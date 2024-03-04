<script>
  import Tailwindcss from './Tailwindcss.svelte';
  import Router from 'svelte-spa-router';
  import Header from './components/Header.svelte';
  import Footer from './components/Footer.svelte';
  import Home from './routes/Home.svelte';
  import Login from './routes/Login.svelte';
  import Register from './routes/Register.svelte';
  import NotPermitted from './routes/NotPermitted.svelte';
  import Cars from './routes/Cars.svelte';
  import Reservations from './routes/Reservations.svelte';
  import Accounts from './routes/Accounts.svelte';
  import MyReservations from './routes/MyReservations.svelte';
  import Car from './routes/Car.svelte';
  import Archive from './routes/Archive.svelte';
  import Rules from './routes/Rules.svelte';
</script>

<Tailwindcss />
<Header />
<Router
  routes={{
    '/': Home,
    '/login': Login,
    '/register': Register,
    '/cars': Cars,
    '/cars/:id': Car,
    '/reservations': Reservations,
    '/accounts': Accounts,
    '/my-reservations': MyReservations,
    '/archive': Archive,
    '/rules': Rules,
    '/*': NotPermitted,
  }}
/>
<Footer />
