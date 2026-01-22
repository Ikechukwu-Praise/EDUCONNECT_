// snack/screens/SignUpScreen.js
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity } from 'react-native';
import { supabase } from '../lib/supabase';

export default function SignUpScreen({ navigate }) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  return (
    <View style={{padding:20}}>
      <Text style={{fontSize:24,fontWeight:'700',marginBottom:12}}>Sign Up</Text>
      <TextInput placeholder="Full name" value={name} onChangeText={setName} style={{borderWidth:1,borderColor:'#ddd',padding:8,borderRadius:6,marginBottom:10}} />
      <TextInput placeholder="Email" value={email} onChangeText={setEmail} style={{borderWidth:1,borderColor:'#ddd',padding:8,borderRadius:6,marginBottom:10}} />
      <TextInput placeholder="Password" secureTextEntry value={password} onChangeText={setPassword} style={{borderWidth:1,borderColor:'#ddd',padding:8,borderRadius:6,marginBottom:10}} />

      <TouchableOpacity onPress={async () => {
        try {
          const { data, error } = await supabase.auth.signUp({ email, password, options: { data: { full_name: name } } });
          if (error) return alert(error.message || 'Sign-up error');
          alert('Sign-up successful. Check your email for confirmation.');
          navigate('signin');
        } catch (err) {
          alert('Sign-up failed');
        }
      }} style={{backgroundColor:'#7c3aed',padding:12,borderRadius:8}}>
        <Text style={{color:'#fff',textAlign:'center'}}>Create Account</Text>
      </TouchableOpacity>

      <TouchableOpacity onPress={() => navigate('home')} style={{marginTop:12}}>
        <Text style={{color:'#999'}}>Back</Text>
      </TouchableOpacity>
    </View>
  );
}
