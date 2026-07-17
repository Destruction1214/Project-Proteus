return {
    --Min/Max_Era Values required, can be any integer
    --Research optional, if not needed put 'nil'
    --Research is the FighterResearch that has to be set for that Fighter to be added to the pool

    --["PROTEUS_GROUP_NAME"] = {
        --["OPTION1"] = {Min_Era = X, Max_Era = X, Research = "FighterResearch"},
        --["OPTION2"] = {Min_Era = X, Max_Era = X, Research = "FighterResearch"},
        --["OPTION3"] = {Min_Era = X, Max_Era = X, Research = "FighterResearch"},
        --...
    --},

    ["IMPERIAL_LIANNA"] = {
        ["TIE_X1_SQUADRON"] = {
            Min_Era = 1, Max_Era = 20, Research = nil
        },
        ["TIE_POD_SQUADRON"] = {
            Min_Era = 1, Max_Era = 20, Research = nil
        },
        ["TIE_AGGRESSOR_SQUADRON"] = {
            Min_Era = 1, Max_Era = 20, Research = nil
        },
        ["TIE_SENTINEL_SQUADRON"] = {
            Min_Era = 1, Max_Era = 20, Research = nil
        },
        ["TIE_X2_SQUADRON"] = {
            Min_Era = 1, Max_Era = 20, Research = nil
        },
    },
}