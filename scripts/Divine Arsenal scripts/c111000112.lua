--Divine Starslayer - Load Pairot
local s,id,o=GetID()
function s.initial_effect(c)

-- Special summon in the grave
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
e1:SetCode(EFFECT_SPSUMMON_PROC)
e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
e1:SetOperation(s.spop)
c:RegisterEffect(e1)

--special summon
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(id,1))
e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e2:SetProperty(EFFECT_FLAG_DELAY)
e2:SetCode(EVENT_SUMMON_SUCCESS)
e2:SetCountLimit(1)
e2:SetTarget(s.sptg2)
e2:SetOperation(s.spop2)
c:RegisterEffect(e2)
local e3=e2:Clone()
e3:SetCode(EVENT_SPSUMMON_SUCCESS)
c:RegisterEffect(e3)

--level
local e0=Effect.CreateEffect(c)
e0:SetDescription(aux.Stringid(id,2))
e0:SetType(EFFECT_TYPE_FIELD)
e0:SetRange(LOCATION_MZONE)
e0:SetCode(EFFECT_CHANGE_LEVEL)
e0:SetTargetRange(LOCATION_MZONE,0)
e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x880))
e0:SetValue(12)
c:RegisterEffect(e0)

end

s.listed_series={0x880}
s.listed_names={id}

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	--You cannot Special Summon from the Extra Deck for the rest of this turn, except Rank 12 Xyz Monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_XYZ) and c:IsRank(12)) end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Clock Lizard Check
	aux.addTempLizardCheck(c,tp,function(e,c) return not (c:IsOriginalType(TYPE_XYZ) and c:IsOriginalRank(12)) end)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x880) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
