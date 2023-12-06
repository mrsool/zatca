# zatca
![](https://img.shields.io/gem/v/zatca) ![](https://img.shields.io/github/workflow/status/mrsool/zatca/Ruby)

A Ruby library for generating QR Codes for the e-invoice standard by ZATCA in Saudi Arabia.

✅ Validated to have the same output as [ZATCA's SDK](https://zatca.gov.sa/en/E-Invoicing/SystemsDevelopers/ComplianceEnablementToolbox/Pages/DownloadSDK.aspx) as of 15 November 2023.

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

## Notice of Non-Affiliation and Disclaimer
This library is not affiliated, associated, authorized, endorsed by, or in any way officially connected with ZATCA (Zakat, Tax and Customs Authority), or any of its subsidiaries or its affiliates. The official ZATCA website can be found at https://zatca.gov.sa.

## Phase 2
Documentation is still in progress, and can be found in this repository's [wiki](https://github.com/mrsool/zatca/wiki)
