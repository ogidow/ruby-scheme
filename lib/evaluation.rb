class Evaluation
  $lookup_func_table = {
    :+ => [:prim, -> (x, y){x + y}],
    :- => [:prim, -> (x, y){x - y}],
    :* => [:prim, -> (x, y){x * y }]
  }

  def _eval(exp)
    if list?(exp)
      func = _eval(car(exp))
      args = eval_list(cdr(exp))
      apply(func, args)
    else
      if immediate_val?(exp)
        exp
      else
        lookup_primitive_func(exp)
      end
    end
  end

    private
      def list?(exp)
        exp.is_a?(Array)
      end

      def immediate_val?(exp)
        exp.is_a?(Numeric)
      end

      def lookup_primitive_func(exp)
        $lookup_func_table[exp]
      end

      def eval_list(exp)
        exp.map{|e| _eval(e)}
      end

      def car(array)
        array[0]
      end

      def cdr(array)
        array[1..-1]
      end

      def apply(func, args)
        apply_primitive_func(func, args)
      end

      def apply_primitive_func(func, args)
        func_val = func[1]
        func_val.call(*args)
      end
end
