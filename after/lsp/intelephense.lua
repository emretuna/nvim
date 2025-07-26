local home = os.getenv 'HOME'
return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { '.git', 'composer.json' },
  settings = {
    completion = {
      enabled = true,
    },
    format = {
      enable = false, -- use boolean
    },
    settings = {
      intelephense = {
        telemetry = {
          enabled = false,
        },
        stubs = {
          'acf-pro',
          'bcmath',
          'bz2',
          'calendar',
          'Core',
          'curl',
          'date',
          'exif',
          'json',
          'genesis',
          'polylang',
          'Relection',
          'wordpress',
          'wordpress-globals',
          'woocommerce',
          'wp-cli',
          'zip',
          'zlib',
        },
        diagnostics = {
          enable = true,
        },
        environment = {
          includePaths = home .. '~/.composer/vendor/php-stubs/',
        },
        files = {
          maxSize = 5000000,
        },
      },
    },
  },
}
