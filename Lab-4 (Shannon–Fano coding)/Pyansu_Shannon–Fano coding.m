% Shannon–Fano coding
% Created on: 18/02/25
% Author: Pyansu Nahak, BT22ECE131

function [codes, codewords] = Experiment_4()
    clc;
    clear;
    close all;
    
    symbols = ['A', 'B', 'C', 'D', 'E'];
    probabilities = [0.5, 0.2, 0.2, 0.05, 0.05];
    
    if sum(probabilities) ~= 1
        probabilities = probabilities / sum(probabilities);
    end
    
    n = length(symbols);
    items = cell(n, 2);
    for i = 1:n
        items{i, 1} = symbols(i);
        items{i, 2} = probabilities(i);
    end
    
    items = sortrows(items, -2);

    [codes, codewords] = generate_code(items, '');
    
    fprintf('Shannon-Fano Codes:\n');
    for i = 1:length(codes)
        fprintf('Symbol: %s, Code: %s\n', codes{i}, codewords{i});
    end
end

function [codes, codewords] = generate_code(items, prefix)
    
    n = size(items, 1);
    
    if n == 1
        codes = {items{1, 1}};
        codewords = {prefix};
        return;
    end
    
    cumulative_prob = cumsum([items{:, 2}]);
    [~, split_idx] = min(abs(cumulative_prob - cumulative_prob(end) / 2));  % Split where sum is closest to 50%

    left_items = items(1:split_idx, :);
    right_items = items(split_idx+1:end, :);
    
    [left_codes, left_codewords] = generate_code(left_items, [prefix '0']);
    [right_codes, right_codewords] = generate_code(right_items, [prefix '1']);
    
    codes = [left_codes, right_codes];
    codewords = [left_codewords, right_codewords];
end