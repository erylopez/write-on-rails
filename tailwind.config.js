module.exports = {
  darkMode: 'media',
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    "./node_modules/flowbite/**/*.js"
  ],
  plugins: [
    require('flowbite/plugin'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/line-clamp'),
  ],
  safelist: [
    'bg-green-200/50',
    'text-green-700',
    'dark:bg-green-700/50',
    'dark:text-green-200',
    'border-green-400',
    'bg-red-200/50',
    'text-red-700',
    'dark:bg-red-700/50',
    'dark:text-red-200',
    'border-red-400'
  ],

}
