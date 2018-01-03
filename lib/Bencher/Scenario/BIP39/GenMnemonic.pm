package Bencher::Scenario::BIP39::GenMnemonic;

# DATE
# VERSION

use Nodejs::Util qw(get_nodejs_path nodejs_module_path);

our $scenario = {
    summary => 'Benchmark generating 20k 128bit mnemonic phrase',
    participants => [
        {
            module => 'Bitcoin::BIP39',
            code_template => 'for (1..20_000) { Bitcoin::BIP39::gen_bip39_mnemonic() }',
        },
    ],
    precision => 6,
};

{
    unless (get_nodejs_path()) {
        warn "nodejs not available, skipped benchmarking bip39js";
        last;
    }
    unless (nodejs_module_path("bip39")) {
        warn "nodejs module 'bip39' not available, skipped benchmarking bip39js";
        last;
    }
    push @{ $scenario->{participants} }, +{
        name => 'bip39js',
        helper_modules => ["Nodejs::Util"],
        code_template => q|Nodejs::Util::system_nodejs('-e', 'bip39 = require("bip39"); for (i=0; i<20000; i++) { bip39.generateMnemonic() }')|,
    };
}

$scenario;

1;
# ABSTRACT:
