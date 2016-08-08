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
      def lookup_var(var, environments)
        env = environments.find{|env| env.key?(var) }
        if env.nil?
          raise "couldn't find value to variables: #{var}"
        end
        env[var]
      end

      def extend_env(params, args env)
        list = params.zip(args)
        h = {}
        list.each{|key, val| h[key] = val}
        env.unshift(h)
      end

      def eval_let(exp, env)
        params, args, body = let_to_params_args_body(exp)
        new_exp = [[:lambda, params, body]] + args
        _eval(new_exp, env)
      end

      def let_to_params_args_body(exp)
        [exp[1].map{|e| e[0]}, exp[1].map{|e| e[1]}, exp[2]]
      end

      def let?(exp)
        exp[0] == :let
      end

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
