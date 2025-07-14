--Ultra Necrozma
local s,id,o=GetID()
function s.initial_effect(c)
	
    c:EnableReviveLimit()

    -- Ritual Summon
    local e2=aux.AddRitualProcGreaterCode(c,id)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	
	--Attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(0x2f)
	c:RegisterEffect(e3)

	--indes battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(s.indval1)
	c:RegisterEffect(e1)

	--indes effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(s.indval2)
	c:RegisterEffect(e4)

	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.distg)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)

	--return to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(s.con)
	e6:SetTarget(s.tdtg)
	e6:SetOperation(s.tdop)
	c:RegisterEffect(e6)

	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(s.descon)
	e7:SetTarget(s.destg)
	e7:SetOperation(s.desop)
	c:RegisterEffect(e7)
	
	--remove
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,4))
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(s.rmcon)
	e8:SetTarget(s.rmtg)
	e8:SetOperation(s.rmop)
	c:RegisterEffect(e8)

	--send
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,5))
	e9:SetCategory(CATEGORY_TOGRAVE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(s.sendcon)
	e9:SetTarget(s.sendtg)
	e9:SetOperation(s.sendop)
	c:RegisterEffect(e9)	

	--to hand
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,6))
	e10:SetCategory(CATEGORY_TOHAND)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCondition(s.hcon)
	e10:SetTarget(s.htg)
	e10:SetOperation(s.hop)
	c:RegisterEffect(e10)
	
	--equip
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,7))
	e11:SetCategory(CATEGORY_EQUIP)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(s.zonecon)
	e11:SetTarget(s.zonetg)
	e11:SetOperation(s.zoneop)
	c:RegisterEffect(e11)	
end

s.listed_series={0xa6d}
s.listed_names={id}

--indestructible
function s.indval1(e,c)
	return c:GetBattleTarget():GetAttribute()&c:GetAttribute()~=0
end

function s.indval2(e,re,rp)
	if not (rp==1-e:GetHandlerPlayer() and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)) then return false end
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsControler(rp) and (rc:IsFaceup() or not rc:IsLocation(LOCATION_MZONE)) then
		return e:GetHandler():IsAttribute(rc:GetAttribute())
	else
		return e:GetHandler():IsAttribute(rc:GetOriginalAttribute())
	end
end

--disable
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_MZONE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_DISABLE_EFFECT)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetValue(RESET_TURN_SET)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5)
	end
end

--return to deck
function s.cfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_DARK) 
	and Card.IsAbleToDeck
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE
	if chkc then return chkc:IsControler(1-tp) and 
		chkc:IsLocation(loc) and chkc:IsAbleToDeck()
	end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,0,loc,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,0,loc,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end

--destroy
function s.desfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(loc)
	end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,0,loc,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,0,loc,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--remove
function s.rmfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_EARTH)
	 and c:IsAbleToRemove(tp,POS_FACEUP)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(loc)
	end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,0,loc,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,0,loc,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--send
function s.sendfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.sendcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.sendfilter,tp,0,LOCATION_MZONE,1,nil)
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

--return to hand
function s.hfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function s.hcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.hfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.htg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE
	if chkc then return chkc:IsControler(1-tp) and 
		chkc:IsLocation(loc) and chkc:IsAbleToHand()
	end
	if chk==0 then return Duel.IsExistingTarget(s.hfilter,tp,0,loc,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.hfilter,tp,0,loc,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.hop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--equip
function s.zonefilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_WIND) 
end
function s.zonecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.zonefilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.zonetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local hand_chk=e:GetHandler():IsLocation(LOCATION_HAND)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.zonefilter(chkc,tp,hand_chk) end
	if chk==0 then return Duel.IsExistingTarget(s.zonefilter,tp,0,LOCATION_MZONE,1,nil,tp,hand_chk) end
end
function s.zoneop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.zonefilter,tp,0,LOCATION_MZONE,1,1,nil,tp,hand_chk)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
