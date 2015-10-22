function output = Code_Rate_Calculator ( lambda_Vector, initial_Parameters )

    syms x;
    lambda_Polynomial = 0;
    for index = 1 : size ( lambda_Vector, 2 )
        lambda_Polynomial = lambda_Polynomial + lambda_Vector ( 1, index ) * x^index;
    end
%     RHO = x ^ power_of_X;

        if ( size ( initial_Parameters ( 1, 2 : end ) , 2 ) == 2 )
            first_Coefficient_of_Row = initial_Parameters (1, 2); 
            first_Power_of_Row = initial_Parameters (1, 3);                
            RHO = first_Coefficient_of_Row * ( x ^ first_Power_of_Row );
            
        elseif ( size ( initial_Parameters ( 1, 2 : end ) , 2 ) == 4 )
            first_Coefficient_of_Row = initial_Parameters (1, 2);
            first_Power_of_Row = initial_Parameters (1, 3);                
            second_Coefficient_of_Row = initial_Parameters (1, 4);            
            second_Power_of_Row = initial_Parameters (1, 5);   
            
            RHO = first_Coefficient_of_Row * ( x^first_Power_of_Row ) + second_Coefficient_of_Row * ( x^second_Power_of_Row ) ;
        end

    
    rate = 1 - ( int ( RHO, 0 , 1 ) / int ( lambda_Polynomial, 0 , 1 ) );
    output = double(vpa(rate));
end