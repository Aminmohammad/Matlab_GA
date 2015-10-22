
function [ranked_all_Chromosomes_of_all_Iterations all_Chromosomes_of_all_Iterations Bests_of_all_Iterations Global_Best] = Genetic_Algorithm_Manager (     initial_Population, ...                  % A Matrix or '' :  Each Column has the results of a Test for All Variables      
                                                                                                                                                            ...                                      % for ex. :     input_Data = [ Cement       :  1  2  3  4  5 ;
                                                                                                                                                            ...                                      %                              Lime_Powder  :  6  7  8  9  10;
                                                                                                                                                            ...                                      %                              Stone_Powder :  11 12 13 14 15;
                                                                                                                                                            ...                                      %                              ...          :       ...
                                                                                                                                                            ...                                      %                            ]
                                                                                                                                                            ...
                                                                                                                                                            initial_Costs, ...                       % A Vertical Vector or ''
                                                                                                                                                            ...
                                                                                                                                                            initial_Parameters, ...                  % Vertical Structure or '' : any Essential parameter for problem (such as u for Cost function)
                                                                                                                                                            ...
                                                                                                                                                            number_of_Vars, ...                      % Number of Decision Variables
                                                                                                                                                            var_Min_Vector, ...                      % Horizontal Vector or '' : Minimum Value of Vars
                                                                                                                                                            var_Max_Vector, ...                      % Horizontal Vector or '' : Maximum Value of Vars
                                                                                                                                                            ...
                                                                                                                                                            draw_the_Convergence_Fig, ...            % 0 or 1 : Draws COnvergence Procedure
                                                                                                                                                            draw_the_Seperated_Histogram_Figs, ...   % 0 or 1 : Draws Seperated Histogram Figures        
                                                                                                                                                            draw_the_Integrated_Histogram_Fig, ...   % 0 or 1 : Draws Integrated Histogram Figure       
                                                                                                                                                            column_Names, ...                        % Column Names for Histogram
                                                                                                                                                            ...
                                                                                                                                                            maximum_Iteration, ...
                                                                                                                                                            population_Size, ...
                                                                                                                                                            p_CrossOver, ...
                                                                                                                                                            p_Mutation, ...
                                                                                                                                                            deviation,...
                                                                                                                                                            ...
                                                                                                                                                            codeRate_Best_Value, ...                 % Baest Value that is Assigned to 'CodeRate' : No Limitation
                                                                                                                                                            codeRate_Deviation, ...                  % 0 <= codeRate_Deviation <= codeRate_Best_Value
                                                                                                                                                            ...
                                                                                                                                                            the_Num_of_Pops_for_Demonstration, ...   % The Number of populations for Demonstration
                                                                                                                                                            ...                                                                                                                                                            
                                                                                                                                                            ranking_Policy )                         % 'Descend' or 'Ascend'   : for 'Descend' the 'Global Best' 'increases'
                                                                                                                                                                                                                 %             : for 'Ascend'  the 'Global Best' 'descreases'
                                                                                                                                           
                                                                            
 % 'Bests_of_all_Iterations' : Vertical Structure >> Each Row has 'Two' Fields :  ( value : Horizontal Values of all Variables ) && ( Total_Cost : Scalar Value of this Chromosome )                                                                             
                    % for ex. : Bests_of_all_Iterations  :    --------------------------------------------------------
                    %                                        | Value |    10 15 16 ... 13    | Total_Cost  |   10     |
                    %                                         --------------------------------------------------------
                    %                                                                   .
                    %                                                                   .
                    %                                                                   .
                    %                                         --------------------------------------------------------
                    %                          Global Best : | Value |    1  9  26 ... 53    | Total_Cost  |   23     |
                    %                                         --------------------------------------------------------
                    
 % 'Global_Best'            : 1X1 Structure >> it has 'Two' Fields :  ( value : Variables of Best Chromosome  ) && ( Total_Cost : Scalar Value of this Chromosome )                                                                             
                    % for ex. : Bests_of_all_Iterations  :    --------------------------------------------------------
                    %                          Global Best : | Value |    20 35 56 ... 23    | Total_Cost  |   11     |
                    %                                         --------------------------------------------------------

    %% Phase 1: Determination of initial Conditions
    
        % if initial_Population is 'not' empty, we Should check the 'population_Size' with 'size(initial_Population, 2)'
        %    if these values are 'not' the same, we should replace 'size(initial_Population, 2)' instead of 'population_Size'
            if isempty(initial_Population) == 0
                if ( size(initial_Population, 2) >= population_Size )
                    initial_Population = initial_Population (:, 1 : population_Size);   % Elimination of Additional Columns ( Tests)
                    fprintf('Because that "size(initial_Population, 2) >= population_Size " >>> additional Columns (Tests) of "initial_Population" were eliminated.\n');
                else
                    population_Size = size(initial_Population, 2);
                    fprintf('Because that "size(initial_Population, 2) < population_Size " >>> population_Size = size(initial_Population, 2).\n');
                end
            end
        
        % Generic Algorithm Conditions ( Even Numbers for n_Crossover & n_Mutation )

            if ( floor(p_CrossOver * population_Size)/2 ) ==  floor( floor(p_CrossOver * population_Size)/2 )
                n_Crossover = floor(p_CrossOver * population_Size);
            else
                n_Crossover = floor(p_CrossOver * population_Size) - 1 ;
            end
            
            if ( floor(p_Mutation * population_Size)/2 ) ==  floor( floor(p_Mutation * population_Size)/2 )
                n_Mutation = floor(p_Mutation * population_Size);
            else
                n_Mutation = floor(p_Mutation * population_Size) - 1 ;
            end     

    %% Phase 2: Determination of Initial Population 

%         chromosome_Population = struct('value',[],'Total_Cost',[]);
%         chromosome_Population = repmat(chromosome_Population, population_Size, 1);
        
%         best_Total_Cost   = struct('value',[],'Total_Cost',[]);
%         best_Total_Cost   = repmat(best_Total_Cost, maximum_Iteration +1, 1);    
        
%         all_Chromosomes_of_all_Iterations   = struct('value',[],'Total_Cost',[]);
%         all_Chromosomes_of_all_Iterations   = repmat(all_Chromosomes_of_all_Iterations, (( maximum_Iteration + 1 ) * population_Size), 1);  

        for loop_Index=1 : population_Size

            % Saving each Chromosome Value in Chromosome_Population(i).value
                if ( isempty (initial_Population) == 1)   % In this Case, we have No 'Initial Population'
                    temp_Random_Vector = Real_Random_Values ( var_Min_Vector, var_Max_Vector, 1, number_of_Vars ); % Horizontal vector
                    chromosome_Population(loop_Index, 1).value = temp_Random_Vector / sum ( temp_Random_Vector );
                    
                elseif ( isempty (initial_Population) == 0)   % In this Case, we have 'Initial Population'
                    chromosome_Population(loop_Index, 1).value = initial_Population (:, loop_Index)' ; % Horizontal vector
                end

            % Cost Function of Initial Population          
                if ( isempty (initial_Costs) == 1)   % In this Case, we have No 'Initial Costs'           
                    chromosome_Population(loop_Index, 1).Total_Cost = Primary_Lambda_Cost_Function_Manager ( [chromosome_Population(loop_Index).value] );
                    % chromosome_Population(loop_Index, 1).Total_Cost : Vertical Structure
                    
                elseif ( isempty (initial_Costs) == 0)   % In this Case, we have 'Initial Costs'
                    chromosome_Population(loop_Index, 1).Total_Cost = initial_Costs (loop_Index, 1) ; 
                    % chromosome_Population(loop_Index, 1).Total_Cost : Vertical Structure
                end

        end

        % Saving Best Cost Function of Initial Population
            total_Cost_Vector = [chromosome_Population(:, 1).Total_Cost];
                               % chromosome_Population(:, 1).Total_Cost : Vertical Structure
                               % total_Cost_Vector : Horizontal Vector
                               
            if ( strcmp (ranking_Policy, 'Ascend' ) == 1 )
                [~, Index_Vector] = sort(total_Cost_Vector, 'ascend');

            elseif ( strcmp (ranking_Policy, 'Descend' ) == 1 )
                [~, Index_Vector] = sort(total_Cost_Vector, 'descend');
            end            

            best_Total_Cost(1, 1).value = chromosome_Population(Index_Vector(1,1)).value;
            best_Total_Cost(1, 1).Total_Cost = chromosome_Population(Index_Vector(1,1)).Total_Cost;
            
        % Saving All Initial Chromosome Population
            for index = 1 : size ( chromosome_Population, 1 )
                all_Chromosomes_of_all_Iterations ( index, 1). value = [chromosome_Population( index, 1).value];
                all_Chromosomes_of_all_Iterations ( index, 1). Total_Cost = [chromosome_Population( index, 1).Total_Cost];
            end
        
    %%  Phase 3 : Updating Chromosomes by Crossover and Mutation  
         for iteration_Index = 1: maximum_Iteration  
              fprintf('Loop is in the %d-th Iteration out of %d possible iterations ( Phase 3 : Crossover and Mutation ).\n', iteration_Index, maximum_Iteration);

            %% Part 1: Crossovering population
%                 crossovered_parents=struct('value',[],'Total_Cost',[]);
%                 crossovered_parents=repmat(crossovered_parents, n_Crossover, 1);

                % Selection of Parents for Crossover
                    Selected_Parents_for_Crossover = Crossover_Parents_Selector(chromosome_Population, n_Crossover, 'Minimum_TotalCost', ranking_Policy); %% Methods: 'Minimum_TotalCost' or 'RoulleteWheel'
                                                                                                                                                           % ranking_Policy: 'Ascend' or 'Descend'

                %Crossovering Parents
                    for crossover_Index = 1 : 2 : n_Crossover

                        % Calculation of 'Crossovered_parents'
                            alpha = rand;
                            [crossovered_parent_1, crossovered_parent_2] = Parents_Crosoverer( Selected_Parents_for_Crossover(crossover_Index).value, Selected_Parents_for_Crossover(crossover_Index + 1).value, var_Min_Vector, var_Max_Vector, alpha);

                            crossovered_parents(crossover_Index, 1).value = crossovered_parent_1;
                            crossovered_parents(crossover_Index + 1, 1).value = crossovered_parent_2;

                        % Cost Function of crossovered_parents(i)                    
                            crossovered_parents(crossover_Index, 1).Total_Cost = Primary_Lambda_Cost_Function_Manager ( crossovered_parent_1 );

                        % Cost Function of crossovered_parents(i+1)                    
                            crossovered_parents(crossover_Index + 1 , 1).Total_Cost = Primary_Lambda_Cost_Function_Manager ( crossovered_parent_2 );

                    end


           %% Part 2: Mutating population 
%                 mutated_Populations = struct('value',[],'Total_Cost',[]);
%                 mutated_Populations = repmat(mutated_Populations, n_Mutation, 1);

                for mutation_Index = 1 : n_Mutation

                    % Mutating the Pupulation
                        selected_Poulation_Index_for_Mutation = randsample(1 : size ( chromosome_Population, 1), 1);
                        mutated_Population = Population_Mutator( chromosome_Population( selected_Poulation_Index_for_Mutation ).value, deviation, var_Min_Vector, var_Max_Vector);                    
                        mutated_Populations( mutation_Index, 1 ).value = mutated_Population;

                    % Cost Function of crossovered_parents(i+1)                    
                        mutated_Populations( mutation_Index, 1 ).Total_Cost = Primary_Lambda_Cost_Function_Manager ( mutated_Population );
                        
                end

            %% Part 3 : Acumulation of Chromosome_Population && Crossovered_parents && Mutated_Population
                total_Population = [chromosome_Population; crossovered_parents; mutated_Populations];
                chromosome_Population = Total_Population_Selector ( total_Population, population_Size, 'Minimum_TotalCost', ranking_Policy); %% Methods: 'Minimum_TotalCost' or 'RoulleteWheel'
                                                                                                                                              % ranking_Policy: 'Ascend' or 'Descend'

                best_Total_Cost(iteration_Index + 1, 1).value = chromosome_Population(1,1).value;
                best_Total_Cost(iteration_Index + 1, 1).Total_Cost = chromosome_Population(1,1).Total_Cost;

                % Saving All Chromosomes from all Iterations
                    total_Chromosomes_of_each_Iteration = [crossovered_parents; mutated_Populations];
                    priliminary_Size_of_All_Chromosomes_of_all_Iterations = size( all_Chromosomes_of_all_Iterations, 1);
                    for index = 1 : size (total_Chromosomes_of_each_Iteration, 1)
                        all_Chromosomes_of_all_Iterations ( priliminary_Size_of_All_Chromosomes_of_all_Iterations + index, 1). value = [total_Chromosomes_of_each_Iteration( index, 1).value];
                        all_Chromosomes_of_all_Iterations ( priliminary_Size_of_All_Chromosomes_of_all_Iterations + index, 1). Total_Cost = [total_Chromosomes_of_each_Iteration( index, 1).Total_Cost];
                    end

         end  

    %% phase 5 : Returning the Output
        % best_Total_Cost : Vertical Structure (row_Number = Number of Iterations)
        % [best_Total_Cost(1, 1).value] : Horzontal Vector (col_Number = Number of Decision Variables)
    
        % Making 'Bests_of_all_Iterations' : Vertical Structure
            for row_Index = 1 : size (best_Total_Cost, 1)
                Bests_of_all_Iterations(row_Index, 1).value      = [best_Total_Cost(row_Index, 1).value];
                Bests_of_all_Iterations(row_Index, 1).Total_Cost = [best_Total_Cost(row_Index, 1).Total_Cost];
            end
        
        % Making 'Global_Best' : 1X1 Structure            
            Global_Best.value      = [best_Total_Cost(end, 1).value];
            Global_Best.Total_Cost = [best_Total_Cost(end, 1).Total_Cost];
            
        % Soting the 'all_Chromosomes_of_all_Iterations'
% all_Chromosomes_of_all_Iterations = all_Chromosomes_of_all_Iterations ( population_Size + 1 : end , 1 ) ; % Eliminate this line  : Just for  Mr. Behboodi'd Project
            total_Costs_of_all_Chromosomes_of_all_Iterations = [all_Chromosomes_of_all_Iterations(:,1).Total_Cost];

            if ( strcmp (ranking_Policy, 'Ascend' ) == 1 )
                [~, Index_Vector] = sort(total_Costs_of_all_Chromosomes_of_all_Iterations, 'ascend');

            elseif ( strcmp (ranking_Policy, 'Descend' ) == 1 )
                [~, Index_Vector] = sort(total_Costs_of_all_Chromosomes_of_all_Iterations, 'descend');
            end 

            for index = 1 : size ( all_Chromosomes_of_all_Iterations, 1 )
                ranked_all_Chromosomes_of_all_Iterations ( index, 1). value = [all_Chromosomes_of_all_Iterations(Index_Vector( 1, index), 1).value];
                ranked_all_Chromosomes_of_all_Iterations ( index, 1). Total_Cost = [all_Chromosomes_of_all_Iterations(Index_Vector( 1, index), 1).Total_Cost];
            end

    %% phase 4 : Extraction of Ranked-Lambda-Populations
        Iteration_UpperBound = size ( ranked_all_Chromosomes_of_all_Iterations, 1 );
        for index = 1 : Iteration_UpperBound
            temp_Ranked_Matrix_of_all_Chromosomes_of_all_Iterations_Based_on_Lambda ( index , 1 : number_of_Vars ) = [ranked_all_Chromosomes_of_all_Iterations( index, : ). value]; 
            
            fprintf('Loop is in the %d-th Iteration out of %d possible iterations ( Phase 4 : Extraction of Ranked-Lambda-Populations ).\n', index, Iteration_UpperBound );

        end
        
    %% phase 5 : Calculation of F and Attaching F of each Lambda         
        F_or_FInt_of_all_Chromosomes_Ranked_Based_on_Lambda = Secondary_F_Cost_Function_Manager( temp_Ranked_Matrix_of_all_Chromosomes_of_all_Iterations_Based_on_Lambda, initial_Parameters, 5 );        
  
    %% phase 6 : Attaching ( Lambda-Populations && CodeRate && SimgaLambda && F && FINT ) Together  
        Iteration_UpperBound = size (ranked_all_Chromosomes_of_all_Iterations , 1);
        for index = 1 : Iteration_UpperBound
            temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index , 1 : number_of_Vars ) = [ranked_all_Chromosomes_of_all_Iterations( index, 1). value];
            temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index , number_of_Vars + 1 ) = Code_Rate_Calculator ( temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index , 1 : number_of_Vars ), initial_Parameters );
            temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index , number_of_Vars + 2 ) = [ranked_all_Chromosomes_of_all_Iterations( index, 1). Total_Cost];
            temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index , number_of_Vars + 3 ) = F_or_FInt_of_all_Chromosomes_Ranked_Based_on_Lambda ( index , 1 ) ;
            temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index , number_of_Vars + 4 ) = F_or_FInt_of_all_Chromosomes_Ranked_Based_on_Lambda ( index , 2 ) ;
            
            fprintf('Loop is in the %d-th Iteration out of %d possible iterations ( Phase 6 : Attaching ( Lambda-Populations && CodeRate && SimgaLambda && F && FINT ) Together ).\n', index, Iteration_UpperBound );            

        end

    %% phase 7 : Printing Top Generations   
        digits ( 7 );
        number_of_Population_for_Demonstration = the_Num_of_Pops_for_Demonstration;
        fprintf ( '\n\n The %d Best populations are : \n', number_of_Population_for_Demonstration );
        disp ( vpa ( [ (1: number_of_Population_for_Demonstration)' temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT( 1: number_of_Population_for_Demonstration , : ) ] ) );
       
    %% phase 8 : Estracting Best Group Based on 'CodeRate'   
        best_Ranked_Population_based_on_SigmaLambda_and_Selected_Based_on_CodeRate = [];
        for index = 1 : size ( temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT, 1 ) 
            if temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index, 10 ) >= ( codeRate_Best_Value - codeRate_Deviation ) &&  temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index, 10 ) <= ( codeRate_Best_Value + codeRate_Deviation )
                best_Ranked_Population_based_on_SigmaLambda_and_Selected_Based_on_CodeRate = temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( index, : );                
                break;
            end
        end      
        
        if isempty ( best_Ranked_Population_based_on_SigmaLambda_and_Selected_Based_on_CodeRate ) == 0
            fprintf ( '\n\n The Best Population Ranked Based on "SigmaLambda" and Selected Based on "CodeRate" in the range of [ codeRate_Best_Value - codeRate_Deviation, codeRate_Best_Value + codeRate_Deviation ] = [ %d, %d ] is : \n ', codeRate_Best_Value - codeRate_Deviation, codeRate_Best_Value + codeRate_Deviation );        
            disp ( best_Ranked_Population_based_on_SigmaLambda_and_Selected_Based_on_CodeRate );
                
        else
            fprintf ( '\n\n No Population Ranked Based on "SigmaLambda" and Selected Based on "CodeRate" in the range of [ codeRate_Best_Value - codeRate_Deviation, codeRate_Best_Value + codeRate_Deviation ] = [ %d, %d ] was Selected. \n ', codeRate_Best_Value - codeRate_Deviation, codeRate_Best_Value + codeRate_Deviation );        
                
        end
               
    %% Phase 9: Extracting the Histogram of 'Decision Variables'
        if (draw_the_Seperated_Histogram_Figs == 1) || (draw_the_Integrated_Histogram_Fig == 1)
            for row_Index = 1: size(ranked_all_Chromosomes_of_all_Iterations, 1)
                all_Chromosomes_Data_Matrix_for_Histogram(row_Index, :) = [ranked_all_Chromosomes_of_all_Iterations(row_Index, 1).value];
            end

            if (draw_the_Integrated_Histogram_Fig == 1)
                figure;
                set( gcf, 'Name', sprintf('The Total Number of Populations of all Iterations {Maximum_Iteration * [ (P_Crossover + P_Mutation) * Population_Size]} : %d.', size(all_Chromosomes_Data_Matrix_for_Histogram, 1) ));
            end
            
            upper_Limit = size (all_Chromosomes_Data_Matrix_for_Histogram, 2);

            for index = 1 : upper_Limit
                                
                if (draw_the_Integrated_Histogram_Fig == 1)
                    subplot (round (upper_Limit / 2), 2, index);
                    
                elseif (draw_the_Seperated_Histogram_Figs == 1)
                    figure;
                    set( gcf, 'Name', sprintf('The Total Number of Populations of all Iterations {Maximum_Iteration * [ (P_Crossover + P_Mutation) * Population_Size]} : %d.', size(all_Chromosomes_Data_Matrix_for_Histogram, 1) ));
                    
                end
                
                hist (all_Chromosomes_Data_Matrix_for_Histogram ( :, index ))
                title ( sprintf ('Histogram of "%s".', cell2mat ( column_Names ( 1, index ) )  ) );
                xlabel ('Parameter Values')
                ylabel ('Frequency')
            end
        end              
            
    %% phase 10 : Drawing BestFittness
        if (draw_the_Convergence_Fig == 1)
            
            % Bests of all Iterations
                figure;                
                plot([Bests_of_all_Iterations(:, 1).Total_Cost], '*')

                xlabel('Iteration');
                ylabel('Best Cost');
                legend('Total Cost');
                Title = sprintf('Genetic Algorithm Optimization (Bests of all Iterations).\n\n');
                title(Title);
            
            % ranked all Chromosomes of all Iterations ( all CodeRates of all Iterations )                 
                figure;
                x_Label = 1 : size ( temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT, 1 ); 
                plot( x_Label, temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( :, number_of_Vars + 1 ), '*r', 'DisplayName', 'Code-Rate' );

                xlabel('Iteration');
                Title = sprintf('Genetic Algorithm Optimization (Ranked all Chromosomes of all Iterations).\n\n');
                title(Title); 
                
            % ranked all Chromosomes of all Iterations ( all SigmaLambdas of all Iterations ) 
                hold all;
                plot( x_Label, temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( :, number_of_Vars + 2 ), '--b', 'DisplayName','Total Cost (  SigmaLambda )');
                
            % ranked all Chromosomes of all Iterations ( all Fs of all Iterations ) 
                hold all;
                plot( x_Label, temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( :, number_of_Vars + 3 ), '-.g', 'DisplayName','F'); 
                
            % ranked all Chromosomes of all Iterations ( all FINTs of all Iterations ) 
                hold all;
                plot( x_Label, temp_Matrix_of_all_Chromosomes_of_all_Iterations_and_CodeRate_and_LambdaSigma_and_F_and_FINT ( :, number_of_Vars + 4 ), 'y', 'DisplayName','FInt');

                legend('-DynamicLegend');      
                hold off
        end            
end