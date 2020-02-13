module.exports = {
  theme: {
    customForms: theme => ({
      default: {
        checkbox: {
          iconColor: theme('borderColor.red[600]'),
          '&:checked': {
            backgroundColor: theme('colors.white'),
            borderColor: theme('borderColor.red[600]'),
            borderWidth: theme('borderWidth[2]'),
            backgroundColor: theme('colors.red[100]'),
          },
          '&:focus': {
            boxShadow: 'none',
            borderColor: theme('transparent'),
          },
        },
      },
    }),
    extend: {
      fontFamily: {
        header: ['Roboto', 'sans-serif'],
        body: ['"Open Sans"', 'sans-serif']
      }
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/custom-forms'),
  ]
}
