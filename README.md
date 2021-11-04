# zatca-qr-code
![](https://img.shields.io/gem/v/zatca-qr-code) ![](https://img.shields.io/github/workflow/status/mrsool/zatca-qr-code/Ruby)

[🚧 Still being validated by ZATCA](https://github.com/mrsool/zatca-qr-code/issues/3).

A Ruby library for generating QR Codes for the e-invoice standard by ZATCA in Saudi Arabia.

# Installation

## Rubygems
```sh
gem install zatca-qr-code
```

## Bundler
```sh
bundle add zatca-qr-code
```

# Usage

```rb
require "zatca"

tags = {
  seller_name: "Mrsool",
  vat_registration_number: "310228833400003",
  timestamp: "2021-10-20T19:29:32+03:00",
  vat_total: "15",
  invoice_total: "115",
}

ZATCA.render_qr_code(tags)
# => data:image/png;base64,...
# Hint (Try pasting the above into your web browser's address bar)
```

If you'd like to customize the size of the QR Code you can manually use the generator like so:

```rb
require "zatca"

tags = ZATCA::Tags.new({
  seller_name: "Mrsool",
  vat_registration_number: "310228833400003",
  timestamp: "2021-10-20T19:29:32+03:00",
  vat_total: "15",
  invoice_total: "115",
})

generator = ZATCA::QRCodeGenerator.new(tags)
generator.render(size: 512)
```
