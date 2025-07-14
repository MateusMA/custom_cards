--Wild Wave - Radio Dog
local s,id,o=GetID()
function s.initial_effect(c)

	-- Summon without tribute
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SUMMON_PROC)
	e5:SetRange(LOCATION_HAND)
	c:RegisterEffect(e5)

    --lvup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)

    --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

s.listed_series={0xd77}
s.listed_names={id}

--lvup
function s.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsSetCard(0xd77)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

--spsummon
function s.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xd77) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
	    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		    and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) end
	    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
    else
        if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		    and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
	    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	    local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	    if g:GetCount()>=2 then
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		    local sg=g:Select(tp,2,2,nil)
		    local tc=sg:GetFirst()
		    Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		    local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		    tc:RegisterEffect(e1)
		    tc=sg:GetNext()
		    Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		    local e2=e1:Clone()
		    tc:RegisterEffect(e2)
		    Duel.SpecialSummonComplete()
	    end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
	    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		    local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		    tc:RegisterEffect(e1,true)
	    end
	    Duel.SpecialSummonComplete()
    end
end