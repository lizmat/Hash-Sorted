# This modules is prepared to be incorporated into the Rakudo core,
# so it set up to be as performant as possible already using nqp ops.
use nqp;

use Hash::Agnostic:ver<0.0.16+>:auth<zef:lizmat>;
use Array::Sorted::Util:ver<0.0.11+>:auth<zef:lizmat>;

my sub typed-array(Mu \type) {
    nqp::objprimspec(type) ?? array[type] !! Array[type]
}

# for handling .kv
my class KV does PredictiveIterator {
    has @!keys;
    has @!values;
    has int $!elems;
    has int $i;

    method !SET-SELF(\keys, \values) {
        @!keys   := keys;
        @!values := values;
        $!elems = nqp::mul_i(keys.elems,2);
        $!i     = -1;
        self
    }
    method new(\keys, \values) { nqp::create(self)!SET-SELF(keys, values) }

    method pull-one() {
        nqp::islt_i(($i = nqp::add_i($i,1)),$!elems)
          ?? (nqp::bitand_i($i,1)
               ?? @!values
               !! @!keys
             ).AT-POS(nqp::div_i($!i,2))
          !! IterationEnd
    }

    method count-only(--> Int:D) { 
        $!elems - $!i - nqp::islt_i($!i,$!elems) 
    }   
    method sink-all(--> IterationEnd) { $!i = $!elems }
}

#--- Role using the standard &[cmp] --------------------------------------------
role Hash::Sorted[::KeyT = str, ::ValueT = Any] does Hash::Agnostic {

#- start of generated part -----------------------------------------------------
#- Generated on 2021-04-18T11:48:33+02:00 by ./makeGENERIC.raku
#- PLEASE DON'T CHANGE ANYTHING BELOW THIS LINE

    has @.keys;
    has @.values;

    method new() {
        my $self := nqp::create(self);
        nqp::bindattr($self,self,'@!keys',typed-array(KeyT).new);
        nqp::bindattr($self,self,'@!values',typed-array(ValueT).new);
        $self
    }

    method keys(::?ROLE:D:) { @!keys }

#---- Methods needed for consistency -------------------------------------------
    multi method gist(::?ROLE:D:) {
        '{' ~ self.pairs.map( *.gist).join(", ") ~ '}'
    }

    multi method Str(::?ROLE:D:) {
        self.pairs.join(" ")
    }

    multi method raku(::?ROLE:D:) {
        self.rakuseen(self.^name, {
          ~ self.^name
          ~ '.new('
          ~ self.pairs.map({nqp::decont($_).rakuperl}).join(',')
          ~ ')'
        })
    }

#---- Optional methods for performance -----------------------------------------
    method elems(::?ROLE:D:)  { @!keys.elems }
    method end(::?ROLE:D:)    { @!keys.end }
    method values(::?ROLE:D:) { @!values }

    method pairs(::?ROLE:D:) {
        (^@!keys).map: { Pair.new(@!keys.AT-POS($_), @!values.AT-POS($_)) }
    }
    method antipairs(::?ROLE:D:) {
        (^@!keys).map: { Pair.new(@!values.AT-POS($_), @!keys.AT-POS($_)) }
    }
    method kv(::?ROLE:D:) { Seq.new(KV.new(@!keys, @!values)) }

#- PLEASE DON'T CHANGE ANYTHING ABOVE THIS LINE
#- end of generated part -------------------------------------------------------

#--- Mandatory method required by Hash::Agnostic -------------------------------
    method AT-KEY(::?ROLE:D: \key) is raw {
        nqp::if(
          (my \index := finds(@!keys, key)).defined,
          @!values.AT-POS(index),
          Nil
        )
    }
    method ASSIGN-KEY(::?ROLE:D: \key, \value) is raw {
        nqp::if(
          (my \index := finds(@!keys, key)).defined,
          @!values.ASSIGN-POS(index, value),
          @!values.AT-POS(
            inserts(@!keys, key, @!values, value)
          )
        )
    }
    method BIND-KEY(::?ROLE:D: \key, \value) is raw {
        nqp::if(
          (my \index := finds(@!keys, key)).defined,
          @!values.BIND-POS(index, value),
          @!values.AT-POS(
            inserts(@!keys, key, @!values, nqp::decont(value))
          )
        )
    }
    method EXISTS-KEY(::?ROLE:D: \key) {
        finds(@!keys, key).defined
    }
    method DELETE-KEY(::?ROLE:D: \key) {
        nqp::if(
          (my \index := finds(@!keys, key)).defined,
          nqp::stmts(
            (my \value := @!values.AT-POS(index)),
            deletes(@!keys, key, @!values),
            value
          ),
          Nil
        )
    }
}

#--- Role using a custom comparator --------------------------------------------
role Hash::Sorted[::KeyT = str, ::ValueT = Any, :$cmp!] does Hash::Agnostic {

#- start of generated part -----------------------------------------------------
#- Generated on 2021-04-18T11:48:33+02:00 by ./makeGENERIC.raku
#- PLEASE DON'T CHANGE ANYTHING BELOW THIS LINE

    has @.keys;
    has @.values;

    method new() {
        my $self := nqp::create(self);
        nqp::bindattr($self,self,'@!keys',typed-array(KeyT).new);
        nqp::bindattr($self,self,'@!values',typed-array(ValueT).new);
        $self
    }

    method keys(::?ROLE:D:) { @!keys }

#---- Methods needed for consistency -------------------------------------------
    method gist(::?ROLE:D:) {
        '{' ~ self.pairs.map( *.gist).join(", ") ~ '}'
    }

    method Str(::?ROLE:D:) {
        self.pairs.join(" ")
    }

    method perl(::?ROLE:D:) is DEPRECATED("raku") {
        self.raku
    }
    method raku(::?ROLE:D:) {
        self.perlseen(self.^name, {
          ~ self.^name
          ~ '.new('
          ~ self.pairs.map({nqp::decont($_).perl}).join(',')
          ~ ')'
        })
    }

#---- Optional methods for performance -----------------------------------------
    method elems(::?ROLE:D:)  { @!keys.elems }
    method end(::?ROLE:D:)    { @!keys.end }
    method values(::?ROLE:D:) { @!values }

    method pairs(::?ROLE:D:) {
        (^@!keys).map: { Pair.new(@!keys.AT-POS($_), @!values.AT-POS($_)) }
    }
    method antipairs(::?ROLE:D:) {
        (^@!keys).map: { Pair.new(@!values.AT-POS($_), @!keys.AT-POS($_)) }
    }
    method kv(::?ROLE:D:) { Seq.new(KV.new(@!keys, @!values)) }

#- PLEASE DON'T CHANGE ANYTHING ABOVE THIS LINE
#- end of generated part -------------------------------------------------------

#--- Mandatory method required by Hash::Agnostic -------------------------------
    method AT-KEY(::?ROLE:D: \key) is raw {
        nqp::if(
          (my \index := finds(@!keys, key, :$cmp)).defined,
          @!values.AT-POS(index),
          Nil
        )
    }
    method ASSIGN-KEY(::?ROLE:D: \key, \value) is raw {
        nqp::if(
          (my \index := finds(@!keys, key, :$cmp)).defined,
          @!values.ASSIGN-POS(index, value),
          @!values.AT-POS(
            inserts(@!keys, key, @!values, value, :$cmp)
          )
        )
    }
    method BIND-KEY(::?ROLE:D: \key, \value) is raw {
        nqp::if(
          (my \index := finds(@!keys, key, :$cmp)).defined,
          @!values.BIND-POS(index, value),
          @!values.AT-POS(
            inserts(@!keys, key, @!values, nqp::decont(value), :$cmp)
          )
        )
    }
    method EXISTS-KEY(::?ROLE:D: \key) {
        finds(@!keys, key, :$cmp).defined
    }
    method DELETE-KEY(::?ROLE:D: \key) {
        nqp::if(
          (my \index := finds(@!keys, key, :$cmp)).defined,
          nqp::stmts(
            (my \value := @!values.AT-POS(index)),
            deletes(@!keys, key, @!values, :$cmp),
            value
          ),
          Nil
        )
    }
}

# vim: ft=raku expandtab sw=4
