import { writable } from 'svelte/store';

//modal data
export const header = writable('');
export const description = writable('');
export const button = writable('');

//user data
export const isUserLoggedIn = writable(false);
export const user = writable('');
export const userMail = writable('');
export const accountType = writable('');

//cars data
export const cars = writable([]);
