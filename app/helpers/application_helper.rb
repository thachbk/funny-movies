# frozen_string_literal: true

module ApplicationHelper
  def truncate_description(description, length: 100)
    if description.length > length
      "#{description[0...length]}..."
    else
      description
    end
  end

  # the time complexity of the palindrome_string? method is O(n), where n is the length of the input string.
  def palindrome?(args)
    return false unless args.is_a?(String)

    refined_string = args.downcase.gsub(/[^a-z0-9]/, '')
    return false if refined_string.empty?

    length = refined_string.length
    (0..length / 2).each do |i|
      return false if refined_string[i] != refined_string[- 1 - i]
    end

    true
  end

  def rotate_90_counter_clockwise(matrix)
    raise ArgumentError, 'Expected a array with an n-by-n matrix' unless square_matrix?(matrix) # O(n)

    # rotate the matrix 90 degrees counter-clockwise
    length = matrix.length

    rotated_matrix = Array.new(length) { Array.new(length) } # O(n*n)
    (0...length).each do |i|
      (0...length).each do |j|
        rotated_matrix[i][j] = matrix[j][length - 1 - i]
      end
    end
    # O(N*N)

    rotated_matrix
  end

  # overall: O(n) + O(n) + O(N*N) = O(N*N)
  # space complexity: O(N*N)

  private

  def check_palindrome(input)
    input == input.reversive
  end

  def recursive_check_palindrome(input)
    return true if input.length <= 1

    return false unless input.first == input.last

    recursive_check_palindrome(input.sub)
  end

  def square_matrix?(matrix)
    return false unless matrix

    return false unless matrix.is_a?(Array)

    matrix.each do |row|
      return false unless row.is_a?(Array) && row.length == matrix.length
    end

    true
  end
end
