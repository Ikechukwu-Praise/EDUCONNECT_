import { redirect } from "next/navigation"
import { createClient } from "@/lib/supabase/server"
import { AppNav } from "@/components/app-nav"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { BookOpen, Upload, Users, Coins, TrendingUp, Download } from "lucide-react"
import Link from "next/link"

export default async function DashboardPage() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect("/auth/login")
  }

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single()

  const { data: recentResources } = await supabase
    .from("resources")
    .select("*, subjects(name)")
    .order("created_at", { ascending: false })
    .limit(5)

  const { data: uploadStats } = await supabase.from("resources").select("id").eq("uploaded_by", user.id)

  const { data: downloadStats } = await supabase.from("resource_downloads").select("id").eq("user_id", user.id)

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-background to-purple-50/20">
      <AppNav />
      <main className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold mb-2">Welcome back, {profile?.full_name?.split(" ")[0] || "Student"}!</h1>
          <p className="text-muted-foreground">Here's what's happening with your account today.</p>
        </div>

        {/* Stats Grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Available Coins</CardTitle>
              <Coins className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{profile?.coins || 0}</div>
              <p className="text-xs text-muted-foreground mt-1">Use to download resources</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Resources Uploaded</CardTitle>
              <Upload className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{uploadStats?.length || 0}</div>
              <p className="text-xs text-muted-foreground mt-1">Shared with community</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Resources Downloaded</CardTitle>
              <Download className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{downloadStats?.length || 0}</div>
              <p className="text-xs text-muted-foreground mt-1">Access your library</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">University</CardTitle>
              <TrendingUp className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-lg font-bold truncate">{profile?.university || "N/A"}</div>
              <p className="text-xs text-muted-foreground mt-1">Your institution</p>
            </CardContent>
          </Card>
        </div>

        {/* Quick Actions */}
        <div className="grid md:grid-cols-3 gap-6 mb-8">
          <Link href="/subjects">
            <Card className="hover:border-primary/50 transition-colors cursor-pointer h-full">
              <CardContent className="pt-6">
                <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                  <BookOpen className="h-6 w-6 text-primary" />
                </div>
                <h3 className="font-semibold mb-1">Browse Subjects</h3>
                <p className="text-sm text-muted-foreground">Explore resources across different subjects</p>
              </CardContent>
            </Card>
          </Link>

          <Link href="/rooms">
            <Card className="hover:border-primary/50 transition-colors cursor-pointer h-full">
              <CardContent className="pt-6">
                <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                  <Users className="h-6 w-6 text-primary" />
                </div>
                <h3 className="font-semibold mb-1">Study Rooms</h3>
                <p className="text-sm text-muted-foreground">Join or create collaborative study sessions</p>
              </CardContent>
            </Card>
          </Link>

          <Link href="/profile">
            <Card className="hover:border-primary/50 transition-colors cursor-pointer h-full">
              <CardContent className="pt-6">
                <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                  <Coins className="h-6 w-6 text-primary" />
                </div>
                <h3 className="font-semibold mb-1">Buy Coins</h3>
                <p className="text-sm text-muted-foreground">Purchase more coins to access resources</p>
              </CardContent>
            </Card>
          </Link>
        </div>

        {/* Recent Resources */}
        <Card>
          <CardHeader>
            <CardTitle>Recent Resources</CardTitle>
          </CardHeader>
          <CardContent>
            {recentResources && recentResources.length > 0 ? (
              <div className="space-y-3">
                {recentResources.map((resource) => (
                  <div key={resource.id} className="flex items-center justify-between p-3 bg-muted/50 rounded-lg">
                    <div className="flex-1">
                      <h4 className="font-medium">{resource.title}</h4>
                      <p className="text-sm text-muted-foreground">
                        {resource.subjects?.name} • {resource.coin_cost} coins
                      </p>
                    </div>
                    <Link href={`/subjects/${resource.subject_id}`}>
                      <Button size="sm" variant="outline">
                        View
                      </Button>
                    </Link>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-center text-muted-foreground py-8">No resources yet</p>
            )}
          </CardContent>
        </Card>
      </main>
    </div>
  )
}
