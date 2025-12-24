// snack/screens/ResourcesScreen.js
import React from 'react';
import { View, Text, ScrollView, TouchableOpacity } from 'react-native';
import ResourceCard from '../components/ResourceCard';

export default function ResourcesScreen({ navigate }) {
  const [resources, setResources] = React.useState([]);
  const [loading, setLoading] = React.useState(false);

  React.useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      try {
        const { data, error } = await (await import('../lib/supabase')).supabase.from('resources').select('*').eq('public', true).limit(50);
        if (error) {
          console.warn('Failed to load resources', error.message);
          if (mounted) setResources([]);
        } else if (mounted) {
          setResources(data || []);
        }
      } catch (err) {
        console.warn(err);
      } finally { if (mounted) setLoading(false); }
    };
    load();
    return () => { mounted = false; };
  }, []);

  return (
    <ScrollView contentContainerStyle={{padding:20}}>
      <Text style={{fontSize:22,fontWeight:'700',marginBottom:12}}>Resources</Text>
      {loading && <Text>Loading...</Text>}
      {!loading && resources.length === 0 && <Text style={{color:'#666'}}>No resources found.</Text>}
      {resources.map(r => (
        <ResourceCard key={r.id} title={r.title || 'Untitled'} coins={r.price_coins || 0} onPress={() => alert(`Unlock ${r.title} for ${r.price_coins} coin(s) - placeholder`)} />
      ))}

      <TouchableOpacity onPress={() => navigate('subjects')} style={{marginTop:20}}>
        <Text style={{color:'#999'}}>Back</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}
