--Rainbow Bridge of Legends
local s,id,o=GetID()
function s.initial_effect(c)
    --spsummon Rainbow Dragon
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --special summon a fusion
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(aux.bfgcost)
	e2:SetLabelObject(e0)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end

--spsummon Rainbow Dragon
function s.confilter(c)
	return c:IsSetCard(0x1034)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0x2034)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=Duel.GetMatchingGroup(s.confilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
    local location=LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and gc:GetCount()>6	and Duel.IsExistingMatchingCard(s.filter,tp,location,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,location)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetMatchingGroup(s.confilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
    local location=LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or gc:GetCount()<7 then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,location,0,nil,e,tp)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

--special summon a fusion
function s.cfilter(c,tp,se)
	return c:IsSetCard(0x2034) and c:IsType(TYPE_FUSION)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
		and (se==nil or c:GetReasonEffect()~=se)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(s.cfilter,1,nil,tp,se)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x2034) and c:IsType(TYPE_FUSION)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
		and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(s.spfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg
	if #eg==1 then
		tg=eg:Clone()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tg=eg:FilterSelect(tp,s.spfilter,1,1,nil,e,tp)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
