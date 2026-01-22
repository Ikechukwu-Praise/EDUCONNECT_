-- Create coin_transactions table for payment tracking
CREATE TABLE IF NOT EXISTS coin_transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  coins_purchased INTEGER NOT NULL,
  amount_paid DECIMAL(10,2) NOT NULL,
  payment_method TEXT NOT NULL,
  status TEXT DEFAULT 'completed',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE coin_transactions ENABLE ROW LEVEL SECURITY;

-- Create policy for users to see their own transactions
CREATE POLICY "Users can view own transactions" ON coin_transactions
  FOR SELECT USING (auth.uid() = user_id);

-- Create policy for inserting transactions
CREATE POLICY "Users can insert own transactions" ON coin_transactions
  FOR INSERT WITH CHECK (auth.uid() = user_id);