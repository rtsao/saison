@builtin "whitespace.ne"

Source -> Chunk                         {% function(d) { return d[0] } %}


Chunk -> RealContent
       | NonContent
       | NonContent RealContent
       | Chunk NonContent               {% function(d) { return d[0].concat(d[1]) } %}
       | Chunk NonContent RealContent   {% function(d) { return d[0].concat(d[1], d[2]) } %}


NonContent -> Block                     {% function(d) { return d[0] } %}
            | Interpolation             {% function(d) { return d[0] } %}


Interpolation -> "{{" _ Identifier _ "}}"
                            
                                        {% function(d) { return {type: 'Interpolation', value: d[2] }; } %}


Block -> "{%" _ Conditional __ Identifier _ "%}" Chunk "{%" _ "end" _ "%}"

                                        {% function(d) { return {
                                            type: 'Conditional',
                                            condition: d[2][0],
                                            children: d[7]
                                        };} %}


Conditional -> "if" | "unless"


Identifier -> [a-zA-Z_]:+               {% function(d) { return d[0].join('');} %}


RealContent -> Content                  {% function(d) { return d[0] } %}
            | Content "{"               {% function(d) { return {type: 'Content', value: d[0].value + d[1] }; } %}
            | Content "{" "%"           {% function(d) { return {type: 'Content', value: d[0].value + d[1] + d[2] }; } %}
            | "{" NonSpecialStart       {% function(d) { return {type: 'Content', value: d[0] + d[1].value }; } %}
            | Unclosed                  {% function(d) { return d[0] } %}
            | UnclosedInterp            {% function(d) { return d[0] } %}


Content -> NonStart                     {% function(d) { return {type: 'Content', value: d[0] }; } %}
        | NonSpecial                    {% function(d) { return {type: 'Content', value: d[0] }; } %}
        | Content NonStart              {% function(d) { return {type: 'Content', value: d[0].value + d[1] }; } %}
        | Content NonSpecialStart       {% function(d) { return {type: 'Content', value: d[0].value + d[1] }; } %}
        | null                          {% function(d) { return {type: 'Content', value: '' }; } %}


NonStart -> "{" [^%{]                   {% function(d) { return d[0] + d[1]; } %}


NonSpecialStart -> [^{]                 {% function(d) { return d[0] } %}


NonSpecialEnd -> [^}]                   {% function(d) { return d[0] } %}


StartBlock -> "{%"

StartInterp -> "{{"

Unclosed -> StartBlock NonSpecialEnd    {% function(d) { return {type: 'Content', value: d[0] + d[1] }; } %}
          | Unclosed NonSpecialEnd      {% function(d) { return {type: 'Content', value: d[0].value + d[1] }; } %}

UnclosedInterp -> StartInterp NonSpecialEnd {% function(d) { return {type: 'Content', value: d[0] + d[1] }; } %}
                | UnclosedInterp NonSpecialEnd {% function(d) { return {type: 'Content', value: d[0].value + d[1] }; } %}

