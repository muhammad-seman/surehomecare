import type { Config } from "tailwindcss";
import { themeColors } from "./app/_utils/constants"

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    fontFamily: {
      "lato": "Lato",
    },
    extend: {
      colors: themeColors,
    },
  },
  plugins: [],
};
export default config;
