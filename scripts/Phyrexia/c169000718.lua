--All Kingdom Throne
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6dc))
	e4:SetValue(s.adval)
	c:RegisterEffect(e4)
    --atk down
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTargetRange(0,LOCATION_MZONE)
    e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
    e6:SetValue(s.adval2)
    c:RegisterEffect(e6)
end

--atk
function s.adval(e,c)
	return Duel.GetCounter(0,1,1,0x1009)*100
end
function s.adval2(e,c)
	return Duel.GetCounter(0,1,1,0x1009)*-100
end