import type { Config } from 'tailwindcss';
const config: Config = { content: ['./app/**/*.{js,ts,jsx,tsx}', './components/**/*.{js,ts,jsx,tsx}'], theme: { extend: { colors: { ink:'#17211d', forest:'#164b3b', mint:'#dff3e9', lime:'#c9f36a', paper:'#f7f8f4' }, boxShadow: { soft:'0 16px 50px rgba(23,33,29,.08)' } } }, plugins: [] };
export default config;
