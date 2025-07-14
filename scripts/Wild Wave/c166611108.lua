--Wild Wave - Shark Hero
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

    --sendtoMZone
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,id)
	e3:SetTarget(s.sendtg)
	e3:SetOperation(s.sendop)
	c:RegisterEffect(e3)

    --sendtodeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+600)
	e4:SetTarget(s.sendtg2)
	e4:SetOperation(s.sendop2)
	c:RegisterEffect(e4)
	
	--Cannot summon monsters except Wild Wave
	local e666=Effect.CreateEffect(c)
	e666:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e666:SetCode(EVENT_SPSUMMON_SUCCESS)
	e666:SetOperation(s.spop3)
	c:RegisterEffect(e666)
end

s.listed_series={0xd77}
s.listed_names={id}

--Cannot summon monsters except Wild Wave
function s.spop3(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0xd77)
end

--spsummon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ep==tp and ec:IsSetCard(0xd77)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end

--send to MZone
function s.sendfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.sendtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(loc)
	end
	if chk==0 then return Duel.IsExistingTarget(s.sendfilter,tp,0,loc,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.sendfilter,tp,0,loc,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.sendop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

--Send to deck
function s.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.sendfilter2(c)
	return c:IsSetCard(0xd77)
end
function s.sendtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sendfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.sendop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
        local g=Duel.GetMatchingGroup(s.sendfilter2,tp,LOCATION_DECK,0,nil)
	    if chk==0 then return g:GetClassCount(Card.GetCode)>2 end
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	    local tg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	    Duel.SendtoGrave(tg,REASON_EFFECT)
    else
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	    local g=Duel.SelectMatchingCard(tp,s.sendfilter2,tp,LOCATION_DECK,0,1,1,nil)
	    if #g>0 then
		    Duel.SendtoGrave(g,nil,REASON_EFFECT)
		    Duel.ConfirmCards(1-tp,g)
	    end
    end
end