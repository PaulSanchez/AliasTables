#!/usr/bin/env ruby -w

# Generate values from a categorical distribution in constant
# time, regardless of the number of categories.  This clever algorithm
# uses conditional probability to construct a table comprised of columns
# which have a primary value and an alias.  Generating a value consists
# of picking any column (with equal probabilities), and then picking
# between the primary and the alias based on appropriate conditional
# probabilities.
#
class AliasTable
  # Construct an alias table from a set of values and their associated
  # probabilities.  Values and their probabilities must be synchronized,
  # i.e., they must be arrays of the same length.  Values can be
  # anything, but the probabilities must be positive Rational numbers
  # that sum to one.
  #
  # *Arguments*::
  #   - +x_set+ -> the set of values from which to generate.
  #   - +p_value+ -> the synchronized set of probabilities associated
  #     with the value set. These values should be Rationals to avoid
  #     rounding errors.
  # *Raises*::
  #   - RuntimeError if +x_set+ and +p_value+s are different lengths.
  #   - RuntimeError if any +p_value+ is negative.
  #   - RuntimeError if +p_value+s don't sum to one. Rationals will avoid this.
  #
  def initialize(x_set, p_value)
    fail 'x_set & p_value must have same length.' if x_set.size != p_value.size
    fail 'p_values must be positive' unless p_value.all? { |value| value > 0 }
    @p_primary = p_value.map(&:rationalize)
    fail 'p_values must sum to 1' unless @p_primary.reduce(:+) == Rational(1)
    @x = x_set.clone.freeze
    @alias = Array.new(@x.length)
    parity = Rational(1, @x.length)
    group = @p_primary.each_index.group_by { |i| @p_primary[i] <=> parity }
    deficit_set = group[-1]
    surplus_set = group[1]
    until deficit_set.empty?
      deficit = deficit_set.pop
      surplus = surplus_set.pop
      @p_primary[surplus] -= parity - @p_primary[deficit]
      @p_primary[deficit] /= parity
      @alias[deficit] = @x[surplus]
      if @p_primary[surplus] == parity
        @p_primary[surplus] = Rational(1)
      else
        (@p_primary[surplus] < parity ? deficit_set : surplus_set) << surplus
      end
    end
  end

  # Return a random outcome from this object's distribution.
  # The generate method is O(1) time, but is not an inversion
  # since two uniforms are used for each value that gets generated.
  #
  def generate
    column = rand(@x.length)
    rand <= @p_primary[column] ? @x[column] : @alias[column]
  end
end
