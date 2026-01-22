import Link from "next/link"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { AlertCircle } from "lucide-react"

export default function AuthErrorPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-purple-50/20 p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="space-y-1 text-center">
          <div className="flex justify-center mb-4">
            <div className="rounded-full bg-destructive/10 p-3">
              <AlertCircle className="h-8 w-8 text-destructive" />
            </div>
          </div>
          <CardTitle className="text-2xl font-bold">Authentication Error</CardTitle>
          <CardDescription>There was a problem with your authentication request</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="bg-muted p-4 rounded-lg text-sm text-muted-foreground">
            <p>This could be due to:</p>
            <ul className="list-disc list-inside mt-2 space-y-1">
              <li>An expired or invalid link</li>
              <li>Network connectivity issues</li>
              <li>An error with your account</li>
            </ul>
          </div>
          <div className="flex gap-3">
            <Link href="/auth/login" className="flex-1">
              <Button className="w-full">Try Login Again</Button>
            </Link>
            <Link href="/auth/sign-up" className="flex-1">
              <Button variant="outline" className="w-full bg-transparent">
                Sign Up
              </Button>
            </Link>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
