// snack/screens/StudyRoomScreen.js
import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, TextInput, ScrollView } from 'react-native';
import { supabase } from '../lib/supabase';

export default function StudyRoomScreen({ navigate }) {
  const [rooms, setRooms] = useState([]);
  const [loading, setLoading] = useState(false);
  const [roomName, setRoomName] = useState('');
  const [subject, setSubject] = useState('Mathematics');

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      try {
        const { data, error } = await supabase.from('study_rooms').select('*');
        if (error) console.warn(error.message);
        else if (mounted) setRooms(data || []);
      } catch (err) {
        console.warn(err);
      } finally { if (mounted) setLoading(false); }
    };
    load();
    return () => { mounted = false; };
  }, []);

  const createRoom = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return alert('Please sign in first');
      const jitsiRoom = `educonnect_${Date.now()}`;
      const { data, error } = await supabase.from('study_rooms').insert({
        name: roomName || 'Study Session',
        subject,
        host_id: user.id,
        jitsi_room: jitsiRoom,
        is_private: false
      }).select();
      if (error) return alert(error.message);
      setRooms([...rooms, data[0]]);
      setRoomName('');
      alert('Room created! Jitsi room ID: ' + jitsiRoom);
    } catch (err) {
      alert('Failed to create room');
    }
  };

  const joinRoom = (jitsiId) => {
    alert(`Jitsi room: ${jitsiId}\n\nIn web: Open https://meet.jitsi.org/${jitsiId}\nIn Snack: This would open via WebView component.`);
  };

  return (
    <ScrollView contentContainerStyle={{padding:20}}>
      <Text style={{fontSize:22,fontWeight:'700',marginBottom:12}}>Study Rooms</Text>

      <View style={{backgroundColor:'#f0f0f0',padding:12,borderRadius:8,marginBottom:12}}>
        <Text style={{marginBottom:8}}>Create a Room</Text>
        <TextInput placeholder="Room name (optional)" value={roomName} onChangeText={setRoomName} style={{borderWidth:1,borderColor:'#ddd',padding:8,borderRadius:6,marginBottom:8}} />
        <TextInput placeholder="Subject" value={subject} onChangeText={setSubject} style={{borderWidth:1,borderColor:'#ddd',padding:8,borderRadius:6,marginBottom:8}} />
        <TouchableOpacity onPress={createRoom} style={{backgroundColor:'#7c3aed',padding:10,borderRadius:6}}>
          <Text style={{color:'#fff',textAlign:'center'}}>Create Room</Text>
        </TouchableOpacity>
      </View>

      <Text style={{fontSize:16,fontWeight:'600',marginBottom:8}}>Available Rooms</Text>
      {loading && <Text>Loading...</Text>}
      {!loading && rooms.length === 0 && <Text style={{color:'#666'}}>No rooms yet. Create one above!</Text>}
      {rooms.map(r => (
        <View key={r.id} style={{padding:10,backgroundColor:'#fff',borderRadius:8,marginBottom:8}}>
          <Text style={{fontWeight:'600'}}>{r.name}</Text>
          <Text style={{fontSize:12,color:'#666'}}>{r.subject}</Text>
          <TouchableOpacity onPress={() => joinRoom(r.jitsi_room)} style={{marginTop:6,backgroundColor:'#3b82f6',padding:8,borderRadius:6}}>
            <Text style={{color:'#fff',textAlign:'center',fontSize:12}}>Join {r.jitsi_room}</Text>
          </TouchableOpacity>
        </View>
      ))}

      <TouchableOpacity onPress={() => navigate('home')} style={{marginTop:12}}>
        <Text style={{color:'#999'}}>Back</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}
