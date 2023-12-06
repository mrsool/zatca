# zatca
![](https://img.shields.io/gem/v/zatca) ![](https://img.shields.io/github/actions/workflow/status/mrsool/zatca/test.yml?branch=main)

A Ruby library for generating QR Codes and e-invoices according to the standard created by ZATCA in Saudi Arabia.

This library supports both Phase 1 and Phase 2. Phase 2 support is still new so there may be bugs. Please [report any issues](https://github.com/mrsool/zatca/issues/new) you find.

# Installation

## Rubygems
```sh
gem install zatca
```

## Bundler
```sh
bundle add zatca
```

# Usage

## Phase 1
```rb
require "zatca"

tags = {
  seller_name: "Mrsool",
  vat_registration_number: "310228833400003",
  timestamp: "2021-10-20T19:29:32+03:00",
  vat_total: "15",
  invoice_total: "115",
}

ZATCA.render_qr_code(tags: tags)
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

generator = ZATCA::QRCodeGenerator.new(tags: tags)
generator.render(size: 512)
```

## Phase 2
Documentation lives in the [wiki](https://github.com/mrsool/zatca/wiki)

# Notice of Non-Affiliation and Disclaimer
This library is not affiliated, associated, authorized, endorsed by, or in any way officially connected with ZATCA (Zakat, Tax and Customs Authority), or any of its subsidiaries or its affiliates. The official ZATCA website can be found at https://zatca.gov.sa.


