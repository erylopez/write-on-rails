module.exports = {
  darkMode: 'media',
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
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
    'border-red-400',
    'bg-red-600',
    'bg-green-600',
    'border-red-700',
    'border-green-700',
    'text-red-400',
    'text-green-400',
    'dark:text-red-400',
    'dark:text-green-400'
  ],

}
