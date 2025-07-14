--Sacred Lands
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --immune effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.etarget)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
    --Roll dice
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_DICE+CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_FZONE)
    e5:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
    e5:SetCondition(s.discon)
    e5:SetTarget(s.eftg)
	e5:SetOperation(s.efop)
	c:RegisterEffect(e5)
end
--immune
function s.etarget(e,c)
	return c:IsRace(RACE_DIVINE)
end
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--dice
function s.tfilter(c,tp)
	return c:IsControler(tp) and c:IsRace(RACE_DIVINE)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(s.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.thfilter(c)
	return c:IsAbleToHand()
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	    Duel.Destroy(g,REASON_EFFECT)
    elseif dc==2 then
        local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	    local tc=g:GetFirst()
	    while tc do
		    Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		    local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_DISABLE)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		    tc:RegisterEffect(e1)
		    local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
		    e2:SetCode(EFFECT_DISABLE_EFFECT)
		    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		    e2:SetValue(RESET_TURN_SET)
		    tc:RegisterEffect(e2)
		    tc=g:GetNext()
	    end
	elseif dc==3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	    if #g>0 then
		    Duel.SendtoHand(g,nil,REASON_EFFECT)
		    Duel.ConfirmCards(1-tp,g)
	    end
	elseif dc==4 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE) <=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil,e,tp)
        local tc=g:GetFirst()
	    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		    local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		    tc:RegisterEffect(e1,true)
	    end
	    Duel.SpecialSummonComplete()
	elseif dc==5 then
        Duel.SetTargetPlayer(1-tp)
        local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	    local dam=Duel.GetFieldGroupCount(1-tp,0xe,0)*500
	    Duel.Damage(p,dam,REASON_EFFECT)
	elseif dc==6 then
        Duel.SetTargetPlayer(tp)
        local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	    local h=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
        Duel.SetTargetParam(6-h)
		if h>=6 then return end
	    Duel.Draw(p,6-h,REASON_EFFECT)
	end
end