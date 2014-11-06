#!/bin/perl -w

# Käsitellään Aleph sequential -tietueita, karsitaan seuraavat tapaukset:
# 1. Ebrary-tietueet
# 2. Osakohdetietueet
# 3. AMK-opinnäytteet

use strict;
use utf8;

binmode(STDOUT, ':utf8');

my $beg_time = time;