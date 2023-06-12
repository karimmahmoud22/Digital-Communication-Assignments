function [] = semi_log_plot_BER(BER_matched_cases ,BER_rect_cases,BER_theoretical)
figure();
semilogy(-2:5,BER_matched_cases);
%hold all
%semilogy(-2:5,BER_theoretical,'r');
grid on
title('BER matched ')
ylabel('BER')
xlabel('E_b/N_0 in db')
legend(' BER for matched Filter',' BER for theoritical');

end 