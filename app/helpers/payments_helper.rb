module PaymentsHelper
    
    def able_to_refund?(payment)
        #8日以上あとであればfalse
        if (Time.now.to_i - payment.created.to_i)/(3600*24) >= 8 then return false end
        #payment_intentを取得
        pi = PaymentLog.find_by(:payment_intent=>payment.payment_intent)
        #ログがなければfalse
        if pi.blank? then return false end
        #チケットがなければfalse
        if Ticket.find_by(:payment_log_id=>pi.id).blank? then return false end
        #チケット数が合わなければfalse(すでに１チケットでも使っていれば)
        if pi.course.tickets != current_user.tickets.find_by(:payment_log_id=>pi.id).amount then return false end
        #すでに返金済みであればfalse
        if payment.refunded == true then return false end
            
        #ここまで到達すれば
        true
            
    end
    
end
