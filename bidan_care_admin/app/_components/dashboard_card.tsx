interface DashboardCardProps {
  title: string
  value: number | string
}
function DashboardCard({ title, value }: DashboardCardProps) {
  return (
    <div className="
    p-5 min-w-64 h-36
    border-b-8 border-b-primary
    bg-white shadow-lg shadow-black/20
    ">
    <p className="text-black/40">{title}</p>
      <h1 className="text-5xl font-bold px-3 pt-2">{value}</h1>
    </div>
  )
}

export default DashboardCard