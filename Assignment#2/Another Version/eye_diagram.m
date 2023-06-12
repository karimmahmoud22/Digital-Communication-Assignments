function [] = eye_diagram (samples_generated , number_of_samples)

rolloff_values = [0, 0, 1, 1];
delay_values = [2, 8, 2, 16];
    for i = 1:length(rolloff_values)
        Filter = rcosine(1, number_of_samples, 'sqrt', rolloff_values(i), delay_values(i));
        transmited = conv(samples_generated, Filter);
        received = conv(samples_generated, Filter);
        
        eyediagram(transmited, number_of_samples);
        title("Transmitted signal when rolloff=" + rolloff_values(i) + " delay=" + delay_values(i));
        
        eyediagram(received, number_of_samples);
        title("Received signal when rolloff=" + rolloff_values(i) + " delay=" + delay_values(i));
   end

end 